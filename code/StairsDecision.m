function [layerNr, stairselected, statstairs] = StairsDecision(xpos,...
    ypos, Vectorfields, layer, stairselected, Layer)
% StairsElection: hands over the chosen stairs for each pedestrian.
% 
% Input: X-Position, Y-Position and number of other pedestrians, who are
%   going to the each target.
%
% Output: The chosen target and the updated vector stairselected.

% initialize statstairs as 0 (condition to run the function)
statstairs = 0;

m = size(Vectorfields,1);
% distance: vector containg the distance to each target
% set distance to inf first
distance = inf(m,1);

% distance: vector containing distance to each target
for i=1:m
    distance(i,1) = Vectorfields{i,1}(ypos,xpos,3);
end

% locate distance to clostest target, c is the value of the layer with the
% minimal distance
min_distance = min(distance);
V = find(distance == min_distance);
if size(V,1) > 1
    c = V(1);
else
    c = V;
end

% choose closest target if there is only one target.
if m == 1
    if layer ~= c
        % raise stairselected by one
        stairselected(c) = stairselected(c) + 1;
        layerNr = c;
        % pedestrian made his decision, he will not able to choose the
        % target anymore.
        statstairs = 1;
    else
        layerNr = c;
    end

    
elseif m > 1
    
    % find positions of the targets
    [row,col] = find(Layer(:,:,c) == inf);

    % creates an matrix end_x with the positions [x,y] as entries
    endpoint(:,1)=[col(1);row(1)];
    
    % if condition in order to find out where the pedestrian stays.
    % Afterwards, he can decide between the stairs on the lefthand side and
    % the stairs on the righthand side
    if xpos <= endpoint(1,1) && c == 1
        d = c;
        sec_distance = distance(d);
    elseif xpos <= endpoint(1,1) && c ~= 1
        d = c - 1;
        sec_distance = distance(d);
    elseif xpos > endpoint(1,1) && c ~= m
        d = c + 1;
        sec_distance = distance(d);
    elseif xpos > endpoint(1,1) && c == m
        d = c;
        sec_distance = distance(d);
    end
    
    % calculate the relative distance between closest and second closest
    % distance.
    reldiff_dist = min_distance/(sec_distance + min_distance);
    
    % calculate the relative amount of pedestrians going to the closest 
    % and second closest target.
    reldiff_ped = stairselected(c) / (stairselected(c) +...
        stairselected(d));
 

    %% StairsElection-Model
    % each pedestrian can choose between closest and second closest target.

    % take closest stairs if pedestrian just got spawned
    if layer == 0
        
        % the pedestrian takes the closest target when he enters the
        % platform.
        stairselected(c) = stairselected(c) + 1;
        layerNr = c;
        
    % the pedestian is already on its way
    else
        
        % the decision depends on the absolute amount of pedestrians, who
        % will go to each target
        p_abs = 0.02 * (stairselected(c) - 35);
        
        % the pedestrian is not going to change stairs if p_abs is near 0
        if p_abs > rand() && reldiff_dist > 0.35
            
            % calculate the total probability to change stairs depending
            % on the weight of the to probabilities Inf_reldiff_dist
            % and inf_reldiff_ped.
            totProb = 4 * (reldiff_dist)^3 * (reldiff_ped)^3;
            
            % pedestrian takes second closest target if the total
            % probability is high
            if totProb > rand()
                layerNr = d;
                stairselected(c) = stairselected(c) - 1;
                stairselected(d) = stairselected(d) + 1;
                statstairs = 1;
            else
                layerNr = c;
            end
        else
            layerNr = c;
        end
    end
end

end