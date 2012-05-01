% Modeling and Simulating Social Systems with MATLAB
% BlueMen - Pedestrian Dynamics
% Dominic Hänni, Patrick Manser, Stefan Zoller

% This is the main file. Therefore, the iterations over time and over all
% of the pedestrians is done in here, which leads to the calculation of the
% forces, as well as the integrations to calculate the velocities and
% positions. In the end, these informations are used to plot the situations
% and to create the movie files.

run init

% time loop
for t = (1 + dt) : dt : T
    
    % loop over pedestrians
    for i = 1 : nrped
        
        if (pedM(status, 1) == 1 || pedM(status, 1) == 2)
        
            % loop over every other pedestrian
            for j = 1 : nrped
                
                if (i ~= j)
                    
                    % calculation of the pedestrian interaction force
                    d_ped = norm(pedM(pos, i) - pedM(pos, j)); % distance between pedestrians i and j
                    r_ped = (pedM(radius, i) + pedM(radius, j)); % radii of the two pedestrians
                    n_ped = (pedM(pos, i) - pedM(pos, j)) / d_ped;  % normalized vector from pedestrians j to i
                    e_ped = pedM(velo, i) / norm(pedM(velo, i));  % normalized velocity vector of i
                    phi_ped = acos(dot(-n_ped, e_ped)); % angle between n_ij and e_i
                    
                    pedM(fped, i) = pedM(fped, i) + (A_soc * exp((r_ped - d_ped) / B_soc) * n_ped * (lambda + (1 - lambda) * ((1 + cos(phi_ped)) / 2)) + A_phys * exp((r_ped - d_ped) / B_phys) * n_ped);  % actual force
                end
            end
            
            % calculation of the wall force
            r_wall = pedM(radius, i);  % radius of pedestrian i
            dist_wall = inf;    % set the minimal wall distance to infinity for every timeloop
            
            for j = (pedM(pos(1), i) - intRad_pix) : (pedM(pos(1), i) + intRad_pix) % iteration over x-axis from position of pedestrian with range of radius intRad
                for k = (pedM(pos(2), i) - intRad_pix) : (pedM(pos(2), i) + intRad_pix) % iteration over y-axis from position of pedestrian with range of radius intRad (This means that we are scanning the surrounding square with length 2*intRad of the pedestrian for wall elements.)
                    
                    if (k >= 1 && k <= length(M(:, 1)) && j >= 1 && j <= length(M(1, :)) && M(k, j) == 0) % assure that position to analyze is within our matrix and that there is a wall element
                        
                        if (norm(pedM(pos, i) - [j; k]) <= intRad_pix && norm(pedM(pos, i) - [j; k]) <= dist_wall)  % assure that wall element is within the wall force range and the distance of the new wall force element is smaller than the last one
                            
                            vect_wall = (pedM(pos, i) - [j; k]);    % vector between the closest wall element and the pedestrian i
                            dist_wall = norm(vect_wall);    % distance between the closest wall element and the pedestrian i
                            n_wall = vect_wall / dist_wall;   % normalized vector between the closest wall element and the pedestrian i
                            
                        end     
                    end
                end
            end
            
            if (dist_wall <= intRad_pix)    % assure that there is a wall element in the wall element area before the calculation of the wall force
                pedM(fwall, i) = A_wall * exp((r_wall - dist_wall) / B_wall) * n_wall;  % actual wall force
            end
            
%           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           fwall_max = 250;
%           if(norm(pedM(fwall, i)) > fwall_max)
%                 pedM(fwall, i) = pedM(fwall, i) / norm(pedM(fwall, i)) * fwall_max;               % only implemented for testingsession!
%           end
%           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            
            % calculation of the target force
            pedM(ftarg, i) = [VFX(pedM(pos(2), i), pedM(pos(1), i)) VFY(pedM(pos(2), i), pedM(pos(1), i))]';    % CAUTION: reversed coordinates because of matrix indices
            
            
            % calculation of the total force
            pedM(ftot, i) = 0 * pedM(fped, i) + 1 * pedM(fwall, i) + 100 * pedM(ftarg, i);
            
            
            % calculation of the acceleration, new velocity & position
            pedM(acc, i) = pedM(ftot, i) / pedM(weight, i); % acceleration according to Newton's law of motion
            pedM(velo, i) = pedM(velo, i) + dt * pedM(acc, i);  % intergration according to Euler
            
            if ((norm(pedM(velo, i))) > pedM(vmax, i))   % assure that calculated speed does not excess the speed maximum
                pedM(velo, i) = (pedM(velo, i) / norm(pedM(velo, i))) * pedM(vmax, i);   % reduce velocity to the maximal value
            end
            
            M(pedM(pos(2),i),pedM(pos(1),i)) = 1; % set old position of pedestrian i to one (empty)
            
            pedM(pos, i) = round(pedM(pos, i) + dt * pedM(velo, i)); % calculate new position of pedestrian i (Forward Euler)
            
            if (M(pedM(pos(2),i),pedM(pos(1),i)) == inf)    % check if pedestrian has already reached his final target
                pedM(status, i) = 4;    % set the status of pedestrian i to 'finished'
            end
            
            $$$$$ if (pedM(status, i) ~= 4)   $$$$$ (doesn't work yet)  % assure that the pedestrian is still on his way
                M(pedM(pos(2),i),pedM(pos(1),i)) = 4; % set new position of pedestrian i to four (occupied), if pedestrian has not changed his position, this is only a reset of the previous state
            end
            
        end
    end
    
    M_cell{1, round(((t - 1) / dt))} = M; % save the current Matrix M with the information about the wall and pedestrians
    
    pedM_cell{1, round(((t - 1) / dt))} = pedM; % save results of this particular time in the cell, where all the pedestrian matrizes for all times are saved
    
    pedM(ftarg, :) = zeros(2,1); % all forces for pedestrian i set to zero because of the timeloop ( pedM is only a auxiliary variable )
    pedM(fwall, :) = zeros(2,1);
    pedM(fped, :) = zeros(2,1);
    pedM(ftot, :) = zeros(2,1);
    
end

% clear variables for pedestrians after all of the loops
clear d_ped r_ped n_ped e_ped phi_ped