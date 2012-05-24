function [Vectorfields] = generateVectorfields(M, Layers)
%generateVectorfields: Computes the corresponding vectorfields to a map
%   and x layers. Plots the results if needed.
%
% Input: Map-Matrix containing walls, slow areas, starts. Layer-Matrix 
% containing information about target.
%
% Output: The output is a four dimensional cell array containing the 
% vectorfields for each layer.

% k ist the number of layer which is synonymous with the number of targets.
[m, n, k] = size(Layers);
% find the walls, starts, slow areas in the map to write them in each layer
% matrix
Walls = find(M == 0);
Starts = find(M == 2);
Slow = find(M == 3);
% initialize Vectorfields as a cell with as many lines as existing targets.
% Lateron the lines will be filled up with the vectorfields and the
% distance matrix.
Vectorfields = cell(k,1);

% loop over all layers
for i=1:k
    Layer = Layers(:,:,i);
    Ends = find(Layer == Inf);
    % write the walls into the layer matrix
    Layer(Walls) = 0;
    % write the slow areas into the layer matrix
    Layer(Slow) = 1;
    % write the starts into the layer matrix
    Layer(Starts) = 2;
    % write the ends into the layer matrix
    Layer(Ends) = Inf;
    % generate the vectorfields and the distance matrix with the function
    % computeVF
    [VFX, VFY, I] = computeVF(Layer);
    % initialize the help matrix VF which contains the informations we got
    % with computeVF
    VF = zeros(m,n,3);
    VF(:,:,1) = VFX;
    VF(:,:,2) = VFY;
    VF(:,:,3) = I;
    % fill the i'th line of Vectorfields with VF
    Vectorfields{i,1} = VF;
end
    
end