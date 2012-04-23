% Modeling and Simulating Social Systems with MATLAB
% BlueMen - Pedestrian Dynamics
% Dominic Hänni, Patrick Manser, Stefan Zoller

function draw_Pedestrian(x0, y0, r);
% This function is drawing a Pedestrian
% INPUT: 
%   x0, y0: Central point of the Pedestrian
%   r: Radius of the Pedestrian


hold on

% Define the coordinates for the Pedestrian
angles = 0:0.1:(2*pi);
Pedestrian_x = r*cos(angles);
Pedestrian_y = r*sin(angles);

% Draw the Pedestrian
patch(x0+Pedestrian_x, y0+Pedestrian_y, 'b')