% get_ref_traj_zero.m
% Copyright 2015 Andrew P. Sabelhaus
% This function returns a trajectory of zeroes - i.e., the controller's goal will be to have the system stay still.

function [traj, num_points] = get_ref_traj_zero()
% No inputs.
% Outputs:
%   traj = the output trajectory of the topmost tetrahedron
%   num_points = number of waypoints in the trajectory


% Number of points to have in this trajectory. 
% Note that it's been estimated that timesteps should only put the top tetras about 0.0014 units distance away from each other (in sequential
% timesteps) for the optimization to work.
num_points = 50;

% This trajectory is only zeroes!
traj = [zeros(1, num_points); ...
        zeros(1, num_points); ...
        zeros(1, num_points); ...
        zeros(1, num_points); ...
        zeros(1, num_points); ... 
        zeros(1, num_points); ...
        zeros(1, num_points); ...
        zeros(1, num_points); ...
        zeros(1, num_points); ...
        zeros(1, num_points); ...
        zeros(1, num_points); ...
        zeros(1, num_points)];