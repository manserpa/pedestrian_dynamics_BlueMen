
figure('Position',[ 0,180,3*720,3*130])
hold on
axis([0 720 0 130])

[WallRows, WallCols, V] = find(M == 0);
    
%   Plot Walls
p = plot(WallCols, WallRows, '.k');
set(p, 'MarkerSize', 5);
    
%   Plot Exits
% p = plot(ExitCols, ExitRows, '.r');
% set(p, 'MarkerSize', 10)  ;
for i = 2 : length(pedM_cell)
    clf
    hold on

    axis([0 720 0 130])

    [WallRows, WallCols, V] = find(M == 0);
    
    %   Plot Walls
    p = plot(WallCols, WallRows, '.k');
    set(p, 'MarkerSize', 10);
    draw_Pedestrian(pedM_cell{1,i}(pos,1),pedM_cell{1,i}(radius,1))
    legend(num2str(i*dt + 1), 'location','west')
    
    pause(0.001)
    
end