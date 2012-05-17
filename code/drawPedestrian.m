% Modeling and Simulating Social Systems with MATLAB
% BlueMen - Pedestrian Dynamics
% Dominic Hänni, Patrick Manser, Stefan Zoller

function drawPedestrian(position, r);
% This function is drawing a Pedestrian
% INPUT: 
%   position: [x,y] vector with central point of the Pedestrian 
%   r: Radius of the Pedestrian


hold on

% Define the coordinates for the Pedestrian
angles = 0:0.1:(2*pi);
Pedestrian_x = r*cos(angles);
Pedestrian_y = r*sin(angles);

% Draw the Pedestrian
patch(position(1)+Pedestrian_x, position(2)+Pedestrian_y, 'b')