function  [pedM, nrped_mom] = spawnPed(s_area, pedM, nrped_mom, nrped_end,...
    pos, velo, vmax, weight, radius, tstart, tend, status, mtopix, t)
% spawnSystem: not yet implemented
% intialization of pedestrian matrix

n = length(s_area(1,:));

 % loop over all starting points
 for i=1:n
        % isfree is a variable either 1 (no pedestrian in the examined
        % square) and 0 (there is someone near the spawn point)
        isfree = 1;
        
        % define a square around each starting points to search for 
        % pedestrians in it.
        for y = s_area(2,i) - 6 : s_area(2,i) + 6
            for x = s_area(1,i) - 6 : s_area(1,i) + 6
                if (nrped_mom > 0)
                    % iteration over all pedestrians
                    for k = 1 : nrped_mom
                        % set isfree to 0 if someone is in the square
                        if (pedM(pos, k) == [x; y])
                            isfree = 0;
                        end
                    end
                end
            end
        end
        
        % pedestrians can be spawned if isfree is 1 and the maximum number
        % of pedestrians is not yet achieved
        if (isfree == 1 && nrped_mom < nrped_end)
            % raise the number of pedestrians by one
            nrped_mom = nrped_mom + 1;
            % the pedestrian will spawn at the examined point
            pedM(pos, nrped_mom) = [s_area(1,i) s_area(2,i)]';
            % each has pedestrians has a very little velocity at the
            % beginning
            pedM(velo, nrped_mom) = 1e-5 * ones(2,1);
            % calculate vmax using a distribution with the mean 1.5 *
            % mtopix and the deviation 1.5
            pedM(vmax, nrped_mom) = randnvect(1,1.5,1.5 * mtopix);
            % set the weight of each pedestrian
            pedM(weight, nrped_mom) = 80;
            % set the width of each pedestrian
            pedM(radius, nrped_mom) = 0.3 * mtopix;
            % define the starting time
            pedM(tstart, nrped_mom) = t;
            pedM(tend, nrped_mom) = inf;
            % [0: not started; 1: on the road; 2: on the stairs;
            % 4: finished]
            pedM(status, nrped_mom) = 1; 
            
        end
end   

end