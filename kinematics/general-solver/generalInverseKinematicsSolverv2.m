
%% Spine Parameters
clear

% Geometric parameters
ll = .15; % m, length of long bars
h = .15; % m, height from top to bottom of tetra
ls = h/2; % m, length of short bar
w = sqrt(ll^2-(h/2)^2); % m, width from center of tetra
minCableTension = 0;


% Mass and force parameters
g = 9.8; % m/s^2, acceleration due to gravity
m = .136; % kg/tetra

% xi = [0,.1,0]; % Forget what this does.

%     1  2     3     4    5    6      7       8       9       10
x = [ 0  w     -w    0    0    0+.01  w+.01  -w+.01   0+.01   0+.01]';
y = [ 0  0     0     w    -w   0      0       0       w       -w]';
z = [ 0  -h/2  -h/2  h/2  h/2  .1     .1-h/2  .1-h/2  .1+h/2  .1+h/2]';

forces = [-m*g -m*g]';
coms = [1 6]';

% Fixed nodes should both be part of the same body and not the COM
% NOTE: future revisions will improve upon this limitation, current design
% essentially chooses a vertebra to fix in space rather than the more
% physically accurate model of designating particular nodes as resting on a
% surface.
fixed = [2 3]';
bodies = length(coms); %number of separate bodies

%% Connectivity Matrix
% See H.-J. Schek's "The Force Density Method for Form Finding and
% Computation of General Networks."

% Full connectivity matrix
% Rows 1-4 are cables
% Rows 5-10 are bars
% Columns 1-4 are bottom tetra nodes
% Columns 5-8 are top tetra nodes
%    1  2  3  4  5  6  7  8  9 10
C = [0  1  0  0  0  0 -1  0  0  0;  %  1
     0  0  1  0  0  0  0 -1  0  0;  %  2
     0  0  0  1  0  0 -1  0  0  0;  %  3
     0  0  0  1  0  0  0 -1  0  0;  %  4
     0  0  0  1  0  0  0  0 -1  0;  %  5
     0  0  0  0  1  0 -1  0  0  0;  %  6
     0  0  0  0  1  0  0 -1  0  0;  %  7
     0  0  0  0  1  0  0  0  0 -1;  %  8
     1 -1  0  0  0  0  0  0  0  0;  %  9
     1  0 -1  0  0  0  0  0  0  0;  % 10
     1  0  0 -1  0  0  0  0  0  0;  % 11
     1  0  0  0 -1  0  0  0  0  0;  % 12
     0  0  0  0  0  1 -1  0  0  0;  % 13
     0  0  0  0  0  1  0 -1  0  0;  % 14
     0  0  0  0  0  1  0  0 -1  0;  % 15
     0  0  0  0  0  1  0  0  0 -1]; % 16

% Create vector of distance differences
dx = C*x;
dy = C*y;
dz = C*z;

% number of nodes
n =  size(C,2); %nodes

% identify non-com nodes and connected cables of each body

for a = 1:bodies
    % bars connected to a COM
    temp1 = C(~((C(:,coms(a)))==0),:);
    % removing COM index from list
    temp1(:,coms(a)) = 0;
    
    % nodes of each body sans COM node
    body{a} = find(sum(abs(temp1),1))';
    
    % Cables atached to each body
    cables{a} = find(sum(abs(C(((C(:,coms(a))) == 0),body{a})),2));
    
    % Identify which body is fixed (limited to one fixed body at the
    % moment)
    if any(body{a} == fixed(1))
        fixedBody = a;
    end
    
end

% indices of all cables calculated from connection matrix
allCables = find(sum(abs(C(:,coms)),2) == 0);


s = length(allCables); %number of cables



%% Plot nodal positions
% figure
% plot(x_bot,z_bot,'k.','MarkerSize',10)
% hold on
% plot(x_top,z_top,'r.','MarkerSize',10)

%% Lengths of Bars and Cables
% Necessary later to calculate cable lengths, not necessary in this
% incarnation
l = sqrt(dx.^2+dy.^2+dz.^2);

% Cable diagonal length matrix
l_cables = l(1:s);
L_cables = diag(l_cables);

%% Solve for Reaction Forces
% Assume spine is sitting on a surface. Then there are vertical reaction
% forces at designated nodes

% Solve AR*[R1; R2] = bR, where AR will always be invertible

AR = [1 1;0 (x(fixed(2))-x(fixed(1)))];
bR = [-sum(forces); -sum(forces.*(x(coms)-x(fixed(1))))];
R = AR\bR;

% bR = [sum of forces; sum of moments];


%% Equilibrium Force Equations
% Creates matrices for solution, re-works the old linear algebra to
% directly solve for q. Generally speaking, the original C'QC = f is
% reformulated as
% [dx dx ... dx] .* C]'*q = f

Cprimex = (repmat(dx,1,n).*C)';
Cprimex = Cprimex(:,allCables);
Cprimey = (repmat(dy,1,n).*C)';
Cprimey = Cprimey(:,allCables);
Cprimez = (repmat(dz,1,n).*C)';
Cprimez = Cprimez(:,allCables);

% Moment shorthand function, format of inputs is COM, connected node on body, non-body cable node 
xMom = @(a,b,c) (y(b)-y(a))*(z(c)-z(b)) - (z(b)-z(a))*(y(c)-y(b));
yMom = @(a,b,c) (z(b)-z(a))*(x(c)-x(b)) - (x(b)-x(a))*(z(c)-z(b));
zMom = @(a,b,c) (x(b)-x(a))*(y(c)-y(b)) - (y(b)-y(a))*(x(c)-x(b));

for a = 1:bodies
    %x and z equilibrium criteria
    A1(a,:) = sum(Cprimex(body{a},:),1);
    A2(a,:) = sum(Cprimey(body{a},:),1);
    A3(a,:) = sum(Cprimez(body{a},:),1);
    p1(a,1) = 0;
    p2(a,1) = 0;
    % Applies appropriate constraint to body if it has reaction forces
    
    % NOTE: Review section
    if a == fixedBody
        p3(a,1) = forces(a)+sum(R);
        p4(a,1) = 0;
        p5(a,1) = -R(1)*(x(coms(a))-x(fixed(1)))-R(2)*(x(coms(a))-x(fixed(2)));
        p6(a,1) = 0;
    else
        p3(a,1) = forces(a);
        p4(a,1) = 0;
        p5(a,1) = 0;
        p6(a,1) = 0;
    end
    
    
    % Creates terms associated with moment equilibrium
    A4(a,:) = zeros(1,s);
    A5(a,:) = zeros(1,s);
    A6(a,:) = zeros(1,s);
    for b = 1:s
        if any(cables{a} == allCables(b)) % Is the current cable in the current body's list of attached cables?
            connectedNodes = find(C(b,:)); % Pair of nodes associated with current cable
            if any(body{a} == connectedNodes(1)) 
                A4(a,b) = xMom(coms(a),connectedNodes(1),connectedNodes(2));
                A5(a,b) = yMom(coms(a),connectedNodes(1),connectedNodes(2));
                A6(a,b) = zMom(coms(a),connectedNodes(1),connectedNodes(2));
            else
                A4(a,b) = xMom(coms(a),connectedNodes(2),connectedNodes(1));
                A5(a,b) = yMom(coms(a),connectedNodes(2),connectedNodes(1));
                A6(a,b) = zMom(coms(a),connectedNodes(2),connectedNodes(1));
            end
        end
    end
    
    
end
A = [A1;A2;A3;A4;A5;A6];
p = [p1;p2;p3;p4;p5;p6];

%% Solve Problem for Minimized Cable Tension

% % Solve with YALMIP
% yalmip('clear')
% q = sdpvar(s,1);
% obj = q'*q;
% constr = [A*q == p, L_cables*q >= minCableTension*ones(s,1)];
% options = sdpsettings('solver','quadprog','verbose',0);
% sol = optimize(constr,obj,options);

% Solve with QUADPROG
H = 2*eye(s);
f = zeros(s,1);
Aeq = A;
beq = p;
Aineq = -L_cables;
bineq = -minCableTension*ones(s,1);
% opts = optimoptions(@quadprog,'Display','notify-detailed');
[qOpt, ~, exitFlag] = quadprog(H,f,Aineq,bineq,Aeq,beq);

if exitFlag == 1
    tensions = L_cables*qOpt; % N
%     restLengths = l_cables - tensions/springConstant;
%     if any(restLengths <= 0)
%         display('WARNING: One or more rest lengths are negative. Position is not feasible with current spring constant.')
%     end
else
    display(['Quadprog exit flag: ' num2str(exitFlag)])
    tensions = Inf*ones(s,1);
%     restLengths = -Inf*ones(s,1);
end
