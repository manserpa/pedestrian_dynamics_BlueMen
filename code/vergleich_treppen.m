%% Verlgeich verschiedene Treppen

saveped = 'pedestrian_cell_V';
data_type = '.mat';

nrped=200;

simulationtime=zeros(5,2);

for kl = 1:5
    vers_nr = num2str(kl);
    for load_iter = 1:10
        loadversion = num2str(load_iter);
        load([saveped vers_nr loadversion data_type]);
        
        l = length(pedM_cell);
        
        z = length(find(pedM_cell{1,l}(1,:) ~= 0));
        
        while z == 0
            l = l - 1;
            z = length(find(pedM_cell{1,l}(1,:) ~= 0));
        end
        
        for i=1:nrped
            % controlls, that only pedest who reached the targed are counted
            if pedM_cell{1,l}(20,i) ~= inf
                time(load_iter,i) = pedM_cell{1,l}(20,i);
                runtime(load_iter,i) = pedM_cell{1,l}(20,i) - pedM_cell{1,1}(19,i);

            end
        end
        
        % sorts vector t (highest element at the end
        temp = sort(time(load_iter,:));
        % time last pedestrian reached exit minus time first pedestrian starts
        t_simulation(load_iter) = temp(end) - pedM_cell{1,1}(19,1);
        
        gh(load_iter) = mean(runtime(load_iter,:));
        
        
    end
    % saves median value of first version in (1,1)
    simulationtime(kl,1)=median(t_simulation);
    % saves std value of first version in (1,2)
    simulationtime(kl,2)=std(t_simulation);
    
    runtimepedestrian(kl,1)=mean(gh);
    
end

% Plots
colormap(winter)
subplot(1,3,1)
bar([1:5],simulationtime(:,1)) 
% title('Median simulation time')
xlabel('Map version number')
ylabel('Time [s]')
% subplot(1,3,2)
% bar(simulationtime(:,2))
subplot(1,3,3)
bar([1:5],runtimepedestrian)
% title('Mean walk time')
xlabel('Map version number')
ylabel('Time [s]')
