function [VFX, VFY, I] = computeVF(M)
%computeVF: Computes one vectorfield of a Map for each Layer
%   (each target)
%
%   The input is the m*n - Map containing information about walls, spaces,
%   ends positions.
%   The output are two matrices which contain the x and y components of the
%   vectors of a vectorfield in every point of the input matrix 
%   representing the direction a passenger has to walk to follow the 
%   shortest path to the nearest target. The additional matrix I contains
%   information about the length of way the traveller has to walk to the
%   target.
%
%   As defined in the loadSituation.m file, the codes which we need are:
%   Wall = 0, Space = 1, Exit = inf, Start = 2

% Implement the fast marching toolbox
path(path, 'fast_marching/');
path(path, 'fast_marching/toolbox/');
path(path, 'fast_marching/data/');

[m, n] = size(M);

% Find walls in the input matrix.
F = ones(m , n);
Walls = find(M == 0);
F(Walls) = 0;

% Find exits. Exit are set to infinity in the layer matrix
[ExitRows, ExitCols, V] = find( M == Inf );

% Generate exit vector. Must be done to use the fast marching toolbox
nExits = length(V);
Exits = zeros(2, nExits);
Exits(1, :) = ExitRows;
Exits(2, :) = ExitCols;

% Apply fast marching and gradient. The fast marching toolbox is the base
% of the field force and handles over the direction
options.nb_iter_max = Inf;
[D, S] = perform_fast_marching(F, Exits, options);
% generate the vectorfields VFX and VFY using the function gradientField
[VFX, VFY] = gradientField(D);

% I is a matrix containing the information about the distance to go to the
% chosen target.
[A, I] = convert_distance_color(D,M);

%% Uncomment following lines if colormap-plot needed

fig = figure('visible', 'on');
hold on
imageplot(A);
h= colorbar;
set(h,'fontsize',21);
hold off


%% Uncomment following lines if vectorfield-plot needed
% 
% fig = figure('visible', 'on');
% hold on
% targ = find(M == Inf);
% star = find(M == 2);
% Plo = M;
% Plo(targ) = 1;
% Plo(star) = 1;
% 
% imageplot(Plo);
% 
% x = 1:10:n;
% y = 1:8:m;
% quiver(x, y, VFX(1:8:m,1:10:n), VFY(1:8:m, 1:10:n),0.7,'b');
% hold off


end