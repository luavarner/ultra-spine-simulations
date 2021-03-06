% ref_traj_fig.m
% Plots the spine links so that they can be made into a figure to show the invkin_XZG reference trajectory
% used for the ACC 2017 paper.
% Andrew P. Sabelhaus

close all;

% load in necessary files
path_to_dynamics = '../../../dynamics/2d-dynamics-symbolicsolver';
spine_geometric_parameters_path = strcat(path_to_dynamics, '/spine_geometric_parameters_2D.mat');
load(spine_geometric_parameters_path);

% make sure these paths are set so the invkin function can be called later
path_to_reference_trajectories = '../reference_trajectories';
addpath(path_to_reference_trajectories);

path_to_plotSpineLink = '../../mpc_3d';
addpath(path_to_plotSpineLink);

% Spine geometry:
g = spine_geometric_parameters.g;
N_tetras = spine_geometric_parameters.N; %unused as of 2016-04-24
l = spine_geometric_parameters.l;
h = spine_geometric_parameters.h;
m = spine_geometric_parameters.m;

% make some edits for a better visualization
l = 0.1;
h = 0.1;

% Optimization parameters:
links = 1;
tetra_vertical_spacing = 0.1;
frame = 1;

% Plotting parameters:
figure_window_location = [0, 0, 600 700];
figure_window_color = 'w';
rad = 0.005;
%cmaps = gray(512); % summer(512);
figure_rotation = [0, 0]; %[-20 14]
fontsize = 24;
cable_color = 'r';
cable_thickness = 2;
trajectory_color = 'b';
trajectory_thickness = 2;
mpc_result_color = 'c-';
mpc_result_thickness = 2;
plot_dt = 0.01;
plotting_offset = 30;
lqr_result_color = 'g';
lqr_result_thickness = 2;
anchor = [0 0 rad];

% Use a different color
cmaps = summer(512);
colormap(cmaps(1:256,:))

close;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialize plot

% Create the figure window
figure_handle = figure('position', figure_window_location,'Color',figure_window_color);

% Configure the figure: colors, orientation, etc.
colormap(cmaps(1:256,:));
ax = axes();
grid on;
axis equal;
hold on;
view(figure_rotation);

% Size everything properly
xlim([-0.2 0.2])
ylim([-0.2 0.2])
zlim([-0.1, 0.2])
set(gca,'FontSize',fontsize)

shading interp
light
lighting phong

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot the spine at its rest configuration

% There are 36 states in this simulation, as it stands: 3 bodies * 12 states each.
systemStates = zeros(links, 12);

% The initial state for all of these 36 variables.
x_initial = [];

% Initialize all the states of the system
% This script currently (2016-02-27) considers "k" to be a different index in different circumstances.
% Here, it's used for the system states as k=1 for the first moving tetrahedron, and k=3 for the topmost one.
% But, for plotting, each of these is shifted up: Tetra{1} and transform{1} are for the first (unmoving) tetra, and Tetra{4} is the topmost.

% Plot the first tetrahedron body (k=1 in the Tetra{} usage)
Tetra{1} = [(l^2 - (h/2)^2)^.5, 0, -h/2; ...
    -(l^2 - (h/2)^2)^.5, 0, -h/2; ...
    0, (l^2 - (h/2)^2)^.5, h/2; ...
    0, -(l^2 - (h/2)^2)^.5, h/2];

% Plot a visualization of this spine tetrahedron
[transform{1}, ~] = plotSpineLink(Tetra{1}, rad, ax);

% Turn off all the ticks and axis outlines
set(gca,'YTick',[]);
set(gca,'YTickLabel',[]);
grid off;
%
% Perform 3 iterations: one for each moving tetrahedron.
for k = 1:links
    % Each tetrahedron starts completely still, centered at (x,y) = (0,0) with a z-offset
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
    
    % Save the system states
    % The first state of this tetrahedron is at this starting location
    systemStates(k, :) = [x(k), y(k), z(k), T(k), G(k), P(k), dx(k), dy(k), dz(k), dT(k), dG(k), dP(k)];
    % Append this state to the vector of initial states.
    x_initial = [x_initial; x(k); y(k); z(k); T(k); G(k); P(k); dx(k); dy(k); dz(k); dT(k); dG(k); dP(k)];
    
    % Plot the tetrahedra.
    % Start the initial position of each tetrahedron at the bottom location: center at (0,0,0)
    Tetra{k+1} = [(l^2 - (h/2)^2)^.5, 0, -h/2; ...
        -(l^2 - (h/2)^2)^.5, 0, -h/2; ...
        0, (l^2 - (h/2)^2)^.5, h/2; ...
        0, -(l^2 - (h/2)^2)^.5, h/2];
    
    % Plot a visualization of this spine tetrahedron
    [transform{k+1}, ~] = plotSpineLink(Tetra{k+1}, rad, ax);
    
    % Then, move the tetrahedron body into place by updating the "transform" object.
    % The function below is generated by transforms.m
    % Recall, the system states are indexed starting from 1, but the "Tetra" points are indexed starting with 2 as the bottommost moving vertebra.
    RR{k} =  getHG_Tform(x(k),y(k),z(k),T(k),G(k),P(k));
    % Update the transform object
    set(transform{k+1},'Matrix',RR{k});
    
    % Finally, move the positions of the cables of this tetrahedra into place, by modifying the Tetra{} array.
    % We use this same transform matrix here.
    % First, append a column of "1"s to this set of coordinates, needed for applying the transform.
    % Note again that there are 4 node points per tetra.
    Tetra{k+1} = [Tetra{k+1}, ones(4,1)];
    
    % Move the cables of this tetra into position.
    Tetra{k+1} = RR{k}*Tetra{k+1}';
    % Needs a transpose to return it back to the original orientation
    Tetra{k+1} = Tetra{k+1}';
    % Remove the trailing "1" from the position vectors.
    Tetra{k+1} = Tetra{k+1}(:,1:3);
    
end


% Plot cables
stringEnable = 1;
% Plot the cables for this spine position
if (stringEnable)
    %     % Get the endpoints of the cables
    %     % Find the string points in 3d situation:
    %     String_pts_all = get_spine_cable_points_2d(Tetra, anchor);
    %     % Choose those to be used in 2d situation:
    %     String_pts_ft = String_pts_all(1:3,:);
    %     String_pts =
    String_pts = get_spine_cable_points_2d(Tetra, anchor);
    % Plot. Save the handle so we can delete this set of cables later
    string_handle=plot3(String_pts(:,1),String_pts(:,2),String_pts(:,3),'LineWidth',cable_thickness,'Color',cable_color);
end

% Load in the final position of the vertebrae:
% get the whole reference trajectory
[ref_traj, num_points] = get_ref_traj_invkin_XZG(tetra_vertical_spacing, 80, -1);

% The states at the final point in this trajectory are
systemStates = reshape(ref_traj(:,end), 12, 3)';

%%
% Plot the cables for this spine position
if (stringEnable)
    % delete the previous plotted cables
    delete(string_handle);
        delete(string_handle2);
    % Get the endpoints of the cables
    String_pts = get_spine_cable_points_2d(Tetra, anchor);
    % Plot. Save the handle so we can delete these strings later.
    string_handle=plot3(String_pts(1:3,1),String_pts(1:3,2),String_pts(1:3,3),'LineWidth',cable_thickness,'Color',cable_color);
    string_handle2=plot3(String_pts(5:7,1),String_pts(5:7,2),String_pts(5:7,3),'LineWidth',cable_thickness,'Color',cable_color);
end
%%
% Pull out the states as needed for the transformation below
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

% Update the visualization of the tetrahedra.
% This is done by setting the matrix of "transform{k}" for each tetra.
for k = 1:links
    % The function below is generated by transforms.m
    RR{k} =  getHG_Tform(x(k),y(k),z(k),T(k),G(k),P(k)); % Build graphical model of each link
    %set(transform{k},'Matrix',RR{k});
    set(transform{k+1},'Matrix',RR{k});
end

%%
    
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
    
    if (stringEnable)
    % First, delete the old cables
    delete(string_handle);
    delete(string_handle2);
    % Get the coordinates of the spine cables
    String_pts = get_spine_cable_points(Tetra, anchor);
    % Plot the new strings
    string_handle=plot3(String_pts(1:3,1),String_pts(1:3,2),String_pts(1:3,3),'LineWidth',cable_thickness,'Color',cable_color);
    string_handle2=plot3(String_pts(5:7,1),String_pts(5:7,2),String_pts(5:7,3),'LineWidth',cable_thickness,'Color',cable_color);
end

%set(gca,'YTick',[]);
%set(ax,'YTickLabel',[]);
