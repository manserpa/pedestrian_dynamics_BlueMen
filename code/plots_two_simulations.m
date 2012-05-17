%% Auswertung

load('pedestrian_cell_V11')

nrped=200;

    % runtime for every pedestrian
    
    % finds the length of pedM_cell
    l = length(pedM_cell);
    % stores all entries of the last Matrix in pedM_cell where the y-Position
    % of the pedestrian is not zero.
    z = length(find(pedM_cell{1,l}(1,:) ~= 0));
    
    % "if the pedM matrix in a cell of pedM_cell has entries with nonzero
    % elements in the y-Position, the simulation is still running. That means
    % if the matrix stored im pedM_cell has only zero elements, all passengers
    % have reach the exit."
    % this while loop stores in l the value of the latest matrix with nonzero
    % elements
    while z == 0
        l = l - 1;
        z = length(find(pedM_cell{1,l}(1,:) ~= 0));
    end
    
    
    % iterate over every pedestrian an stores the runtime (tend - tstart)
    for i=1:nrped
        % controlls, that only pedest who reached the targed are counted
        if pedM_cell{1,l}(20,i) ~= inf
            time1(i) = pedM_cell{1,l}(20,i) - pedM_cell{1,l}(19,i);
        end
    end

    
    %% simulationtime untill every pedestrian has reached the exit
    
    % sorts vector t (highest element at the end
    t = sort(t);
    % time last pedestrian reached exit minus time first pedestrian starts
    t_simulation1 = t(end) - pedM_cell{1,1}(19,1);
    t_simulation1;
    
    
    %% Create a timevector
    
    % creates a temporary timevector
    t_temp1 = pedM_cell{1,1}(19,1):dt:t(end);

    
    %% How many Pedestrians are on the platform for timestep i
    
    for i = 1:length(t_temp1)
        
        % count all passengers who are on the platform (with stairs)
        moving_ped1(i) = length(find(pedM_cell{1,i}(21,:)==1));
        moving_ped1(i) = moving_ped1(i) + length(find(pedM_cell{1,i}(21,:)==2));
        
        % count all passengers on stairs
        stairs_ped1(i) = length(find(pedM_cell{1,i}(21,:)==2));
        
        % count all pedestrians sit in traffic (stau)
        % 4 is the minimal speed for an pedestrian if he is doesn't sit in
        % traffic
        zaehler = 0;
        for j = 1:z
            if (norm(pedM_cell{1,i}([3;4],j)) ~= 0)
                zaehler = zaehler + length(find(norm(pedM_cell{1,i}([3;4],j)) < 0.4*pedM_cell{1,i}(15,j)));
            end
        end
        
        standing_ped1(i) = zaehler;
        
        % count all passengers who reached the target
        finished_ped1(i) = length(find(pedM_cell{1,i}(21,:) == 4));
        
    end
    
    for k=1:nrped_mom
        % calculates the median value of t
        t_median1(k) = median(time1(:,k));
        % calculates the mean value of t
        t_mean1(k) = mean(time1(:,k));
        % calculate standarddeviation of t
        t_std1(k) = std(time1(:,k));
    end

    
    %% walked distrance
    
    ped_distance1 = zeros(1,nrped);

    for i = 1:nrped
        for j=2:l
            temp = norm(pedM_cell{1,j}([2;1],i) - pedM_cell{1,(j-1)}([2;1],i));
            ped_distance1(i)=ped_distance1(i) + temp;
        end
    end
    

    
    %% Average Velocity
    
    for i = 1:l
        k=0;
        temp = 0;
        for j = 1:z
            if(pedM_cell{1,i}(21,j)==1)
                k = k + 1;
                temp = temp + norm(pedM_cell{1,i}([velo],j))/pedM_cell{1,i}(vmax,j);
            end
            if(pedM_cell{1,i}(21,j)==2)
                k = k + 1;
                temp = temp + norm(pedM_cell{1,i}([velo],j))/(c_onstairs*pedM_cell{1,i}(vmax,j));
            end
        end
        relative_velo1(i)=temp/k;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    load('pedestrian_cell_V21')

nrped=200;

    % runtime for every pedestrian
    
    % finds the length of pedM_cell
    l = length(pedM_cell);
    % stores all entries of the last Matrix in pedM_cell where the y-Position
    % of the pedestrian is not zero.
    z = length(find(pedM_cell{1,l}(1,:) ~= 0));
    
    % "if the pedM matrix in a cell of pedM_cell has entries with nonzero
    % elements in the y-Position, the simulation is still running. That means
    % if the matrix stored im pedM_cell has only zero elements, all passengers
    % have reach the exit."
    % this while loop stores in l the value of the latest matrix with nonzero
    % elements
    while z == 0
        l = l - 1;
        z = length(find(pedM_cell{1,l}(1,:) ~= 0));
    end
    
    
    % iterate over every pedestrian an stores the runtime (tend - tstart)
    for i=1:nrped
        % controlls, that only pedest who reached the targed are counted
        if pedM_cell{1,l}(20,i) ~= inf
            time2(i) = pedM_cell{1,l}(20,i) - pedM_cell{1,l}(19,i);
        end
    end

    
    %% simulationtime untill every pedestrian has reached the exit
    
    % sorts vector t (highest element at the end
    t = sort(t);
    % time last pedestrian reached exit minus time first pedestrian starts
    t_simulation2 = t(end) - pedM_cell{1,1}(19,1);
    t_simulation2;
    
    
    %% Create a timevector
    
    % creates a temporary timevector
    t_temp2 = pedM_cell{1,1}(19,1):dt:t(end);

    
    %% How many Pedestrians are on the platform for timestep i
    
    for i = 1:length(t_temp2)
        
        % count all passengers who are on the platform (with stairs)
        moving_ped2(i) = length(find(pedM_cell{1,i}(21,:)==1));
        moving_ped2(i) = moving_ped2(i) + length(find(pedM_cell{1,i}(21,:)==2));
        
        % count all passengers on stairs
        stairs_ped2(i) = length(find(pedM_cell{1,i}(21,:)==2));
        
        % count all pedestrians sit in traffic (stau)
        % 4 is the minimal speed for an pedestrian if he is doesn't sit in
        % traffic
        zaehler = 0;
        for j = 1:z
            if (norm(pedM_cell{1,i}([3;4],j)) ~= 0)
                zaehler = zaehler + length(find(norm(pedM_cell{1,i}([3;4],j)) < 0.4*pedM_cell{1,i}(15,j)));
            end
        end
        
        standing_ped2(i) = zaehler;
        
        % count all passengers who reached the target
        finished_ped2(i) = length(find(pedM_cell{1,i}(21,:) == 4));
        
    end
    
    for k=1:nrped_mom
        % calculates the median value of t
        t_median2(k) = median(time2(:,k));
        % calculates the mean value of t
        t_mean2(k) = mean(time2(:,k));
        % calculate standarddeviation of t
        t_std2(k) = std(time2(:,k));
    end

    
    %% walked distrance
    
    ped_distance2 = zeros(1,nrped);

    for i = 1:nrped
        for j=2:l
            temp = norm(pedM_cell{1,j}([2;1],i) - pedM_cell{1,(j-1)}([2;1],i));
            ped_distance2(i)=ped_distance2(i) + temp;
        end
    end
    

    
    %% Average Velocity
    
    for i = 1:l
        k=0;
        temp = 0;
        for j = 1:z
            if(pedM_cell{1,i}(21,j)==1)
                k = k + 1;
                temp = temp + norm(pedM_cell{1,i}([velo],j))/pedM_cell{1,i}(vmax,j);
            end
            if(pedM_cell{1,i}(21,j)==2)
                k = k + 1;
                temp = temp + norm(pedM_cell{1,i}([velo],j))/(c_onstairs*pedM_cell{1,i}(vmax,j));
            end
        end
        relative_velo2(i)=temp/k;
    end
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %% Plots
    
    subplot(3,3,1)
    hist(t_median1)
    title('Histogrammplot traveltime Map 1')
    xlabel('time')
    ylabel('number of pedestrians')
    
    subplot(3,3,2)
    hist(t_median2)
    h = findobj(gca,'Type','patch');
    set(h,'FaceColor','green');
    title('Histogrammplot traveltime Map 2')
    xlabel('time')
    ylabel('number of pedestrians')
    
    subplot(3,3,3)
    plot(t_temp1,standing_ped1,t_temp2,standing_ped2)
    title('Number of pedestrians sit in traffic')
    xlabel('time [s]')
    ylabel('number of pedestrians')
    legend('Map1','Map2')
    
    subplot(3,3,4)
    plot(t_temp1,finished_ped1,t_temp2,finished_ped2)
    title('Finished pedestrians')
    xlabel('time [s]')
    ylabel('number of pedestrians')
    legend('Map1','Map2','location','SouthEast')

    subplot(3,3,5)
    plot(t_temp1,moving_ped1,t_temp2,moving_ped2)
    title('Number of pedestrians on platform incl. stairs')
    xlabel('time')
    ylabel('number of pedestrians')
    legend('Map1','Map2')
    
    subplot(3,3,6)
    plot(t_temp1,stairs_ped1,t_temp2,stairs_ped2)
    title('Number of pedestrians on stairs')
    xlabel('time [s]')
    ylabel('number of pedestrians')
    legend('Map1','Map2')
    
    subplot(3,3,7)
    plot(t_temp1,relative_velo1,t_temp2,relative_velo2)
    ht=title('Average relative velocity to vmax')
    xlabel('time')
    ylabel('velo/vmax')
    legend('Map1','Map2','location','SouthEast')

    subplot(3,3,8)
    hist(ped_distance1)
    title('Walked Distance Map1')
    ylabel('Pedestrian')
    xlabel('Distance')
    
    subplot(3,3,9)
    hist(ped_distance2)
    h = findobj(gca,'Type','patch');
    set(h,'FaceColor','green');
    title('Walked Distance Map2')
    ylabel('Pedestrian')
    xlabel('Distance')
