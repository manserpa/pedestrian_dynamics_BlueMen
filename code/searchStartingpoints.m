function s_area = searchStartingpoints(M)
%searchStartingpoints Returns an matrix s_area with starting positions and
%nbrs_starea with the numbers of starting points.
%   The function takes a matrix M and a value and returns an matrix s_area
%   with all the positions where an entry in M is equal to value.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% find starting areas for pedestrians 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% search matrix M for starting areas and stores the the values in an row-
% and collumvector
[row,col,v] = find(M == 2);

% creates an matrix s_area with the positions [x,y] as entries
for i=1:length(row)
    s_area(:,i)=[col(i);row(i)];
end 

end

