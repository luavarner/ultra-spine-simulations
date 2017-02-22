% scratch.m

% scrap script for executing only parts of ultra_spine_mpc
% begins after generating x_ref and u_ref

%% Build Iterative LQR Controller
disp('Build LQR Controllers for each timestep')

% Create the weighting matrices Q and R

% Version 1: weight on the position states for each tetrahedron equally (no weight on velocity)
% Q = zeros(12);
% Q(1:6, 1:6) = eye(6);
% Q_lqr = 5*kron(eye(3), Q);
% R_lqr = 5*eye(8*links);

% Version 2: weight only on the position of the top tetrahedron
% Q = zeros(36);
% Q(25:30, 25:30) = 50 * eye(6);
% Q_lqr = Q;
% R_lqr = 2*eye(8*links);

% Version 3: weight on all states
Q = 20 * eye(36);
%Q(25:30, 25:30) = 50 * eye(6);
Q_lqr = Q;
R_lqr = 2*eye(8*links);

tic;
P0 = zeros(36);
% Linearize the dynamics around the final point in the trajectory (timestep M.)
[A, B, ~] = linearize_dynamics(x_ref{M}, u_ref{M}, restLengths, links, dt);
% Calculate the gain K for this timestep (at the final timestep, P == the 0 matrix.)
K{1} = -((R_lqr + B'*P0*B)^-1)*B'*P0*A;
% Calculate the first matrix P for use in the finite-horizon LQR below
P_lqr{1} = Q_lqr + K{1}'*R_lqr*K{1} + (A + B*K{1})'*P0*(A + B*K{1});
% Iterate in creating the finite-horizon LQRs, moving backwards from the end state
for k = (M-1):-1:1
    disp(strcat('Controller Build iteration:',num2str(k)))
    % Linearize the dynamics around this timestep
    [A, B, ~] = linearize_dynamics(x_ref{k}, u_ref{k}, restLengths, links, dt);
    % Calculate the gain K for this timestep, using the prior step's P
    K{M-k+1} = -((R_lqr + B'*P_lqr{M-k}*B)^-1)*B'*P_lqr{M-k}*A;
    % Calculate the P for this step using the gain K from this step.
    P_lqr{M-k+1} = Q_lqr + K{M-k+1}'*R_lqr*K{M-k+1} + (A + B*K{M-k+1})'*P_lqr{M-k}*(A + B*K{M-k+1});
end
toc;

disp('Starting simulation')
%% Perform forward simulation and plot results

% Plot the cables for this spine position
if (stringEnable)    
    % delete the previous plotted cables
    delete(string_handle);
    % Get the endpoints of the cables
    String_pts = get_spine_cable_points(Tetra, anchor);
    % Plot. Save the handle so we can delete these strings later.
    string_handle=plot3(String_pts(:,1),String_pts(:,2),String_pts(:,3),'LineWidth',2,'Color','r');
end

plot_dt = 0.01; % Slow down the animation slightly
offset = 30; % Used for animation so it stays still for a few seconds

% Reset all tetrahedra to their beginning states.
for k = 1:links
    % Each tetrahedron starts out where it was in the beginning. See code above in the initialization section.
    x(k) = 0; 
    y(k) = 0.0; 
    z(k) = tetra_vertical_spacing * k; 
    T(k) = 0.0; 
    G(k) = 0.0; 
    P(k) = 0.0;
    dx(k) = 0; 
    dy(k) = 0; 
    dz(k) = 0; 
    dT(k) = 0; 
    dG(k) = 0; 
    dP(k) = 0;
end

% Loop through each timestep, using the controller and plotting.
s = 1;
for t = 1:((M-1)+offset)
    if mod(t, frame) == 0
        tic
        
        while toc < (plot_dt*frame)
            % Wait until time has passed
        end
        
        % Update the visualization of the tetrahedra.
        % This is done by setting the matrix of "transform{k}" for each tetra.
        for k = 1:links
            % The function below is generated by transforms.m
            RR{k} =  getHG_Tform(x(k),y(k),z(k),T(k),G(k),P(k)); % Build graphical model of each link
            %set(transform{k},'Matrix',RR{k});
            set(transform{k+1},'Matrix',RR{k});
        end
        
        % Plot the cables
        if (stringEnable)
            % First, delete the old cables
            delete(string_handle);
            
            % Calculate the new position of the tetra's coordinates, for plotting, based on the transform from the current system states.
            % This section of code is the same as that in the initialization section, but instead, directly indexes the Tetra{} array.
            for k = 2:(links+1)
                % Reset this specific tetrahedron to the initial state of the bottom tetra.
                Tetra{k} = [(l^2 - (h/2)^2)^.5, 0, -h/2, 1; ...
                            -(l^2 - (h/2)^2)^.5, 0, -h/2, 1; ...
                            0, (l^2 - (h/2)^2)^.5, h/2, 1; ...
                            0, -(l^2 - (h/2)^2)^.5, h/2, 1];
                % Move the coordinates of the string points of this tetra into position. 
                % Note that the transforms are indexed as per the system states: set k=1 is for the first moving tetra,
                % AKA the second tetra graphically.
                Tetra{k} = RR{k-1}*Tetra{k}';
                % Needs a transpose!
                Tetra{k} = Tetra{k}';
                % Remove the trailing "1" from the position vectors.
                Tetra{k} = Tetra{k}(:,1:3);
            end
            
            % Get the coordinates of the spine cables
            String_pts = get_spine_cable_points(Tetra, anchor);
            % Plot the new strings
            string_handle=plot3(String_pts(:,1),String_pts(:,2),String_pts(:,3),'LineWidth',2,'Color','r');
        end
        drawnow;
    end
    
    % Update the systemStates matrix with the current states that are saved as individual variables
    for k = 1:links
        systemStates(k, 1) = x(k); 
        systemStates(k, 2) = y(k); 
        systemStates(k, 3) = z(k);
        systemStates(k, 4) = T(k); 
        systemStates(k, 5) = G(k); 
        systemStates(k, 6) = P(k);
        systemStates(k, 7) = dx(k); 
        systemStates(k, 8) = dy(k); 
        systemStates(k, 9) = dz(k);
        systemStates(k, 10) = dT(k); 
        systemStates(k, 11) = dG(k); 
        systemStates(k, 12) = dP(k);
    end
    
    % Forward simulate using the controller

    if ((t > offset) && (t < M + offset))
        % Calculate the input to the system dynamics
        % A general representation of u(t) = K(t) * (x(t) - x_{ref}(t)) + u_{ref}(t)
        % Removed the reference input on 2016-03-01... let's see if the controllers are good enough to keep the system stable!
        control = K{M+offset-t}*(reshape(systemStates', 36, 1) - x_ref{t-offset});% + u_ref{t-offset};
        % Forward simulate using that control input
        systemStates = simulate_dynamics(systemStates, restLengths, reshape(control, 8, 3)', dt, links, noise);
        % Save the result as the next point in the performed trajectory
        % Note that this currently only saves the third tetrahedron's state
        actual_traj(:, s) = systemStates(links, :); 
        % Save the control results for examination later
        actual_control_inputs(:,s) = control;
        s = s + 1;
    end
    
    % Unfoil the new system states back into the series of individual variables
    for k = 1:links
        x(k) = systemStates(k, 1); 
        y(k) = systemStates(k, 2); 
        z(k) = systemStates(k, 3);
        T(k) = systemStates(k, 4); 
        G(k) = systemStates(k, 5); 
        P(k) = systemStates(k, 6);
        dx(k) = systemStates(k, 7); 
        dy(k) = systemStates(k, 8); 
        dz(k) = systemStates(k, 9);
        dT(k) = systemStates(k, 10); 
        dG(k) = systemStates(k, 11); 
        dP(k) = systemStates(k, 12);
    end
    
    % Record this frame for a video
    videoFrames(t) = getframe(gcf);
end

% Plot the resultant trajectory, in full.
plot3(actual_traj(1, :), actual_traj(2, :), actual_traj(3, :), 'g', 'LineWidth', 2);

% Save the last frame, now with full trajectory plotted.
% Save a few of them in a row for a better visualization.
% for frames = 1:5
%     videoFrames(t + frame) = getframe(gcf)
% end

% Save the video, if the save_video flag is set
if(save_video)
    open(videoObject);
    writeVideo(videoObject, videoFrames);
    close(videoObject);
end

% End script.
