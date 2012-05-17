function [stairselected] = TargStat(Layer, M, stairselected)
%TargStat: finds out if the target is achievable from two stairs
%
% Input: Map and Layer, generated in the function getMap
%
% Output: sets the status of each layer two one, if it is achievable from
% two stairs

% get number of layers.
n = size(Layer,3);

for j=1:n
    % search matrix Layer for end areas and stores the the values in an 
    % row- and collumvector
    [row,col] = find(Layer(:,:,j) == inf);

    % creates an matrix end_area with the positions [x,y] as entries
    for i=1:length(row)
        end_area(:,i)=[col(i);row(i)];
    end 
    
    % search for the minimal and maximal x entry, which are decisive when
    % you want to find out if the space on the left and on the right is not
    % a wall
    min_x = min(end_area(1,:));
    max_x = max(end_area(1,:));
    % get the mean of all y entries
    middle_y = round((max(end_area(2,:)) + min(end_area(2,:)))/2);
    
    % if there is no wall on the right and on the left, the stairs is
    % achievable from two sides.
    if M(middle_y, min_x - 1) ~= 0 && M(middle_y, max_x + 1) ~= 0
        stairselected(j,2) = 1;
    end

end