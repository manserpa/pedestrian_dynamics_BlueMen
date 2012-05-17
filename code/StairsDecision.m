function [layerNr, stairselected, statstairs] = StairsDecision(xpos,...
    ypos, Vectorfields, layer, stairselected)
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

% stairselected_red: help vector in which the amount of pedestrians is
% reduced to its half if the target is achievable from two sides
stairselected_red = zeros(m,1);

% distance: vector containing distance to each target
for i=1:m
    distance(i,1) = Vectorfields{i,1}(xpos,ypos,3);
    if stairselected(i,2) == 1
        stairselected_red(i,1) = round(stairselected(i,1) * 0.6);
    else
        stairselected_red(i,1) = stairselected(i,1);
    end
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
    % locate distance to second clostest target for two or more targets. d
    % contains the information which layer has the second minimal distanc
    sec_distance = distance;
    sec_distance(c) = Inf;
    sec_min_distance = min(sec_distance);
    Y = find(distance == sec_min_distance);
    if size(Y,1) > 1
        d = Y(1);
    else
        d = Y;
    end
    
    % calculate the relative distance between closest and second closest
    % distance.
    reldiff_dist = min_distance/ (sec_min_distance + min_distance);
    
    % calculate the relative amount of pedestrians going to the closest 
    % and second closest target.
    reldiff_ped = stairselected_red(c) / (stairselected_red(c) +...
        stairselected_red(d));
 
    

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
        p_abs = 0.02 * (stairselected_red(c) - 35);
        
        % the pedestrian is not going to change stairs if p_abs is near 0
        if p_abs > rand()
            
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