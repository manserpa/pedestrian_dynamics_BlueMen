function [Map, Layers, Train] = getMap()
%getMap: Conversion of a Map.bmp and i Layer.bmp into i+1 
%       two-dimensional matrices containing zeros, ones, twos and inf
%       
%   Only the following colors with their interpretations are allowed:
%
%   Color               Hex         Decsription
%   White               FFFFFF      Free space. Passengers can free walk in
%                                   white areas.
%   Black               000000      Wall.
%   Red                 FF0000      Target for a Traveller.
%   Green               0000FF      Start for a Traveller.
%   Yellow              FFFF00      Slow areas (stairs etc. ).	
%
%   The output map - matrix contains:
%   0 => Wall, 1 => Free space, 2 => starting point, 3 => slow area
%
%   The output layer - matrices contain:
%   1 => Free space, Inf => ending point

% exit is a value to find out how many input layers are given
exit = 1;
% S contains the path to each selected file
S = {};

% Instructions to get the programm working
uiwait(msgbox(['Hey there, ',...
        'please select any map.bmp you like first, ',...
        'then select as many matching layer_i.bmp as ',...
        'targets your map has. When you have selected all ',...
        'your layers, simply press cancel and the programm ',...
        'will start running. ',...
        'Have fun.']));

while exit ~= 0
    % x is the number of layers at the end
    x = exit - 2;
    % first, a map must be selected (see instruction)
    if exit == 1
        % get the path to the file
        [FileName, PathName] = uigetfile('*.bmp', 'Select your Map.bmp');
        % make sure that a map is selected
        if FileName == 0
            exit = 0;
            uiwait(msgbox('Select a Map'));
        else
            % fill S with the path to the file and raise exit by one.
            S{exit,1} = strcat(PathName, FileName);
            exit = exit + 1;
        end

        %% generate a train matrix if there is one
        if exist(strcat(PathName, 'train.bmp')) ~= 0
            pathtrain = strcat(PathName, 'train.bmp');

            % imread generates a matrix containing the RGB value of each 
            % pixel
            rawTrain = imread(pathtrain);
            % find the different colors and locate them in the matrix
            walls = findColor(rawTrain, 0, 0, 0);
            space = findColor(rawTrain, 255, 255, 255);
            
            [lines, columns, depth] = size(rawTrain);

            % fill the matrix Map with numbers representing the special 
            % areas.
            Train = zeros(lines, columns);
            Train(walls) = 0;
            Train(space) = 1;
        else
            Train = 0;
        end
    
    % after selecting a map, as many layers as needed can be selected
    else
        % generate a nice window saying Select Layer'i
        sel = 'Select Layer';
        num = int2str(exit-1);
        [FileName, PathName] = uigetfile('*.bmp', strcat(sel, num));
        % make sure that a layer is selected
        if FileName == 0;
            exit = 0;
        else
            % fill S with the path to the file and raise exit by one.
            S{exit,1} = strcat(PathName, FileName);
            exit = exit + 1;
        end
    end
end

% save number of layers and files in total
nLayers = x;
nFiles = length(S);

%% generate Map

% imread generates a matrix containing the RGB value of each pixel
rawMap = imread(S{1,1});
% find the different colors and locate them in the matrix
walls = findColor(rawMap, 0, 0, 0);
space = findColor(rawMap, 255, 255, 255);
slow = findColor(rawMap, 255, 255, 0);
starts  = findColor(rawMap, 0, 255, 0);

[lines, columns, depth] = size(rawMap);
% make sure that just the needed colors are used
if (length(walls) + length(space) + length(slow) + length(starts))...
        ~= lines*columns
    error('Invalid input Map.');
end

% fill the matrix Map with numbers representing the special areas.
Map = zeros(lines, columns);
Map(walls) = 0;
Map(space) = 1;
Map(slow) = 3;
Map(starts) = 2;

% Add a wall around the map to make sure nobody runs out of the map.
Map(:, 1)       = 0;
Map(1, :)       = 0;
Map(:, columns) = 0;
Map(lines, :)   = 0;


%% generate Layers

% make sure that there is a target
if nLayers == 0
    Layers = [];
    uiwait(msgbox('Select a Map'));
else    
    % loop from 2 to number of files
    for i=2:nFiles
        % imread generates a matrix containing the RGB value of each pixel
        rawLayer = imread(S{i,1});
        % find the different colors and locate them in the matrix rawLayer
        ends = findColor(rawLayer, 255, 0, 0);
        space = findColor(rawLayer, 255, 255, 255);
        
        % make sure that just the needed colors are used
        if (length(ends) + length(space)) ~= lines*columns
            error('Invalid input Layer.');
        end
    
        Layer = zeros(lines, columns);
        % fill the matrix Map with numbers representing the special areas.
        Layer(space) = 1;
        Layer(ends) = inf;
        
        Layers(:,:,i-1) = Layer;
    end
end

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