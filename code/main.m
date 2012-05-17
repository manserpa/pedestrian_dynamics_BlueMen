% Modeling and Simulating Social Systems with MATLAB
% BlueMen - Pedestrian Dynamics
% Dominic Hänni, Patrick Manser, Stefan Zoller

% This is the main file. Therefore, the iterations over time and over all
% of the pedestrians is done in here, which leads to the calculation of the
% forces, as well as the integrations to calculate the velocities and
% positions. In the end, these informations are used to plot the situations
% and to create the movie files.

tic

run init

t = 1 + dt;
%%%%%%%%%%%%%%%
%% time loop %%
%%%%%%%%%%%%%%%
while t < T
    
    % if the maximum amount of pedestrians is not yet achieved, the
    % function spawnPed will spawn pedestrians if there is no pedestrian in
    % the way.
    if nrped_mom < nrped_end
        [pedM, nrped_mom] = spawnPed(s_area, pedM, nrped_mom, nrped_end,...
        pos, velo, vmax, weight, radius, tstart, tend, status, mtopix, t);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% loop over pedestrians %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i = 1 : nrped_mom
        if (pedM(status, i) == 1 || pedM(status, i) == 2)
            
            % implementation of the stairsdecision model. conditions to
            % call out the function: the pedestrian has not already reached
            % his target, the pedestrian has not already made his bevor he
            % entered the platfrom and the pedestrian has just 12 timestep
            % the change the stairs, afterwards he wont change.
            if pedM(status,i) ~= 4 && pedM(statstairs,i) == 0 && ...
                    (pedM(tstart,i) + 15*dt) > t 
                [pedM(layer, i), stairselected, pedM(statstairs, i)] = ...
                    StairsDecision(pedM(pos(2),i), pedM(pos(1), i),...
                    Vectorfields, pedM(layer, i), stairselected);
            end
            
            % loop over every other pedestrian 
            for j = 1 : nrped_mom
                if (i ~= j && pedM(status,j) ~= 4 && pedM(status,j) ~= 0)
                    
                    %% calculation of the pedestrian interaction force
                    % distance between pedestrians i and j
                    d_ped = norm(pedM(pos, i) - pedM(pos, j)); 
                    % radii of the two pedestrians, plus a constant to make
                    % sure that the pedestrians dont overlap
                    r_ped = (pedM(radius, i) + pedM(radius, j)) + c_soc; 
                    % normalized vector from pedestrians j to i
                    n_ped = (pedM(pos, i) - pedM(pos, j)) / d_ped;  
                    % normalized velocity vector of i
                    e_ped = pedM(velo, i) / norm(pedM(velo, i));  
                    % angle between n_ij and e_i
                    phi_ped = acos(dot(-n_ped, e_ped)); 
                    
                    % actual force
                    pedM(fped, i) = pedM(fped, i) + (A_soc * exp((r_ped...
                        - d_ped) / B_soc) * n_ped * (lambda + (1 -...
                        lambda) * ((1 + cos(phi_ped)) / 2)) + A_phys *...
                        exp((r_ped - d_ped) / B_phys) * n_ped);  
                end
            end
            % weight of the social force
            pedM(fped,i) = weight_fsoc * pedM(fped,i);
            
            %% calculation of the wall force
            % radius of pedestrian i minus a constant to make sure that
            % there is not too much free space between wall and pedestrian
            r_wall = pedM(radius, i) - c_wall;  
            % set the minimal wall distance to infinity for every timeloop
            dist_wall = inf;    
            
            % iteration over x-axis from position of pedestrian with 
            % range of radius intRad
            for j = (pedM(pos(1),i)-intRad_pix):(pedM(pos(1),i)+intRad_pix) 
                % iteration over y-axis from position of pedestrian with 
                % range of radius intRad (This means that we are scanning 
                % the surrounding square with length 2*intRad of the 
                % pedestrian for wall elements.)
                for k = (pedM(pos(2),i)-intRad_pix):(pedM(pos(2),i)+...
                        intRad_pix) 
                    % assure that position to analyze is within our matrix 
                    % and that there is a wall element
                    if (k >= 1 && k <= length(M(:, 1)) && j >= 1 ...
                        && j <= length(M(1, :)) && M(k, j) == 0) 
                        
                        % assure that wall element is within the wall force 
                        % range and the distance of the new wall force 
                        % element is smaller than the last one
                        if (norm(pedM(pos, i) - [j; k]) <= intRad_pix &&...
                                norm(pedM(pos, i) - [j; k]) <= dist_wall)  
                            
                            % vector between the closest wall element and 
                            % the pedestrian i
                            vect_wall = (pedM(pos, i) - [j; k]);  
                            % distance between the closest wall element 
                            % and the pedestrian i
                            dist_wall = norm(vect_wall);
                            % normalized vector between the closest wall 
                            % element and the pedestrian i
                            n_wall = vect_wall / dist_wall;   
                            
                        end     
                    end
                end
            end
            
            
            % assure that there is a wall element in the wall element area 
            % before the calculation of the wall force
            if (dist_wall <= intRad_pix)    
                % actual wall force
                pedM(fwall,i)=A_wall*exp((r_wall-dist_wall)/B_wall)*n_wall;
            end
            % weight of the wall force
            pedM(fwall,i) = weight_fwall * pedM(fwall,i);
        
            % VFX and VFY: Vectorfields in x and y-direction
            [VFX] = Vectorfields{pedM(layer, i),1}(:,:,1);
            [VFY] = Vectorfields{pedM(layer, i),1}(:,:,2);
            
            %% calculation of the target force
            % CAUTION: reversed coordinates because of matrix indices
            pedM(ftarg, i) = [VFX(pedM(pos(2), i), pedM(pos(1), i)) ...
                VFY(pedM(pos(2), i), pedM(pos(1), i))]';    
            % weight of the target force
            pedM(ftarg,i) = weight_ftarg * pedM(ftarg,i);
            
            %% calculation of the total force
            pedM(ftot, i) = pedM(fped, i) + pedM(fwall, i) + ...
                pedM(ftarg, i);
            
            
            %% calculation of the acceleration, new velocity & position
            % acceleration according to Newton's law of motion
            pedM(acc, i) = pedM(ftot, i) / pedM(weight, i);
            % intergration according to Euler
            pedM(velo, i) = pedM(velo, i) + dt * pedM(acc, i);  
            
            % if the pedestrian is on the stairs, he is going to slow down
            if M(pedM(pos(2),i),pedM(pos(1),i)) == 3
                % set status to 'on stairs'
                pedM(status,i) = 2;
                if ((norm(pedM(velo, i))) > c_onstairs * pedM(vmax, i))   
                    % reduce velocity to the maximal value
                    pedM(velo, i) = (pedM(velo, i) / norm(pedM(velo, i))) * ...
                        c_onstairs * pedM(vmax, i);   
                end  
            else
                % assure that calculated speed does not excess the speed maximum
                if ((norm(pedM(velo, i))) > pedM(vmax, i))   
                    % reduce velocity to the maximal value
                    pedM(velo, i) = (pedM(velo, i) / norm(pedM(velo, i))) * ...
                        pedM(vmax, i);   
                end
            end
            
            
            %% calculate new position of pedestrian i (Forward Euler)
            pedM(pos, i) = round(pedM(pos, i) + dt * pedM(velo, i)); 
            
            % check if pedestrian has already reached his final target
            if Layer(pedM(pos(2),i),pedM(pos(1),i),pedM(layer,i)) == inf && ...
                    pedM(status,i) ~= 4
                % set the status of pedestrian i to 'finished'
                pedM(status, i) = 4;  
                pedM(tend, i) = t;
                stairselected(pedM(layer,i),1) = ...
                    stairselected(pedM(layer,i),1) - 1;
                
            end
        end
    end
    % save the amount of pedestrians heading to each target for each 
    % timestep
    stair_cell{1, round(((t - 1) / dt))} = stairselected; 
    
    % save results of this particular time in the cell, where all the 
    % pedestrian matrizes for all times are saved
    pedM_cell{1, round(((t - 1) / dt))} = pedM; 
    
    % all forces for pedestrian i set to zero because of the timeloop 
    % (pedM is only a auxiliary variable)
    pedM(ftarg,:) = zeros(2,nrped_end); 
    pedM(fwall,:) = zeros(2,nrped_end);
    pedM(fped,:) = zeros(2,nrped_end);
    pedM(ftot,:) = zeros(2,nrped_end);
    
    % stop criterion: as soon as every pedestrian has reached his target
    % the while loop will stop
    endloop = find(pedM(status,:) == 4);
    if size(endloop,2) == nrped_mom
        break
    else
        t = t + dt;
    end
end

elapsedTime = toc;

% save all variables which are needed to generate a proper print. The while
% loop is to not overwrite existing files
save_iter = 1;
while save_iter < 20
    save_ped = 'pedestrian_cell_v1-';
    version = num2str(save_iter);
    data_type = '.mat';
    if exist([save_ped version data_type]) == 0
        save([save_ped version])
        break
    end
    save_iter = save_iter + 1;
end

% clear variables for pedestrians after all of the loops
clear d_ped r_ped n_ped e_ped phi_ped
