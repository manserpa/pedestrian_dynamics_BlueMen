% Modeling and Simulating Social Systems with MATLAB
% BlueMen - Pedestrian Dynamics
% Dominic Hänni, Patrick Manser, Stefan Zoller

% This is the main file. Therefore, the iterations over time and over all
% of the pedestrians is done in here, which leads to the calculation of the
% forces, as well as the integrations to calculate the velocities and
% positions. In the end, these informations are used to plot the situations
% and to create the movie files.

clear all
clc

init

% time loop
for t = 0 : dt : T
    
    % loop over pedestrians
    for i = 0 : nrped
        
        % loop over every other pedestrian
        for j = (i + 1) : nrped
        
            % calculation of the pedestrian interaction force
            d_ij = norm(x_i - x_j); % distance between pedestrians i and j
            r_ij = (r_i + r_j); % radii of the two pedestrians
            n_ij = (x_i - x_j) / d_ij;  % normalized vector from pedestrians i to j
            e_i = v_i / norm(v_i);  % normalized velocity vector of i
            phi_ij = acos(dot(-n_ij, e_i)); % angle between n_ij and e_i
            
            f_ped_ij = A_i1 * exp((r_ij - d_ij) / B_i1) * n_ij * (lambda_i + (1 - lambda_i) * ((1 + cos(phi)) / 2)) + A_i2 * exp((r_ij - d_ij) / B_i2) * n_ij;  % actual force
            
        end
        
        % calculation of the wall force
        f_wall_i = A_wall * exp((r_wall - d_wall) / B_wall) * n_wall;
        
    end
    
end