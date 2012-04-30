function [Map, Layers] = loadSituation()
%loadSituation: Conversion of k + 1 bmp - images to a map - matrix and a
%               three  dimensional matrix consisting of k two dimensional
%               matrices representing the given subsequent bmp - images.
%
%   Only the following colors with their interpretations are allowed:
%
%   Color               Hex         Decsription
%   White               FFFFFF      Free space. Passengers can free walk in
%                                   white areas.
%   Black               000000      Wall.
%   Red                 FF0000      Target for a group.
%   Green               0000FF      Start for a group.
%   Yellow              FFFF00      Slow areas (stairs etc. ).		==> NOT IMPLEMENTED YET
%	Blue 				0000FF		Safety area. 					==> NOT IMPLEMENTED YET
%
%   The output map - matrix contains:
%   0 => Wall, 1 => Free space, 2 => slow area, 3 => safety area
%
%   The output layer - matrices contain:
%   1 => Free space, 2 => starting point, Inf => ending point

%Generate map.
rawMap = imread('map.bmp');
walls = findColor(rawMap, 0, 0, 0);
space = findColor(rawMap, 255, 255, 255);
space2 = findColor(rawMap, 255, 255, 0);
ends  = findColor(rawMap, 255, 0, 0);
starts  = findColor(rawMap, 0, 255, 0);

[lines, columns, depth] = size(rawMap);


Map = zeros(lines, columns);
Map(walls) = 0;
Map(space) = 1;
Map(space2) = 1;
Map(ends)  = inf;
Map(starts) = 2;


%Add a wall around the map.
Map(:, 1)       = 0;
Map(1, :)       = 0;
Map(:, columns) = 0;
Map(lines, :)   = 0;


end

function [Entries] = findColor(Image, R, G, B)
%findColor: Finds all entries in an image of the specified RGB color.
[m,n,t] = size(Image);
if R > 255 | R < 0 | G > 255 | G < 0 | B > 255 | B < 0 | t ~= 3,
    error('Input error in function findColor');
end

search_px = [R;G;B];

Entries = [];
for i = 1:m,
    for j = 1:n,
        px = [Image(i,j,1); Image(i,j,2); Image(i,j,3)];
        if px == search_px,
            Entries = [Entries; i + j*m - m];
        end
    end
end
end