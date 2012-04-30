function [VFX, VFY] = computeVF(M, File)
%computeVF:    Computes the vectorfield of a map for given starts and ends.
%
%
%   The input is a m*n - matrix containing information about walls, spaces
%   and target positions. The output are two matrices which contain the x
%   and y components of the vectors of a vectorfield in every point of the
%   input matrix representing the direction a passenger has to wolk to
%   follow the shortest path to the nearest target.

%   As defined in the loadSituation.m file, the codes which we need are:
%   Wall = 0, Space = 1, Exit = 3
%
%   Note:   If a file name is specified, the function will store the
%           appearance of the provided matrix into that file.
[m, n] = size(M);
path(path, 'fast_marching/');
path(path, 'fast_marching/toolbox/');
path(path, 'fast_marching/data/');


%   Find walls in the input matrix.
F = ones(m , n);
Walls = find(M == 0);
F(Walls) = 0;

%   Find exits.
[ExitRows, ExitCols, V] = find( M == Inf );

%   Generate exit vector.
nExits = length(V);
Exits = zeros(2, nExits);
Exits(1, :) = ExitRows;
Exits(2, :) = ExitCols;

%   Apply fast marching and gradient.
options.nb_iter_max = Inf;
[D, S] = perform_fast_marching(F, Exits, options);
[VFX, VFY] = gradientField(D);

%   Plot if needed.
if File ~= -1,
    fig = figure('visible', 'on');
      
    %   Plot contours.
    hold on;
    x = 1:4:n;
    y = 1:4:m;
    %   Plot Vectorfield
    quiver(x, y, VFX(1:4:m,1:4:n), VFY(1:4:m, 1:4:n));
    
    [WallRows, WallCols, V] = find(F == 0);
    
    %   Plot Walls
    p = plot(WallCols, WallRows, '.k');
    set(p, 'MarkerSize', 10);
    
    %   Plot Exits
    p = plot(ExitCols, ExitRows, '.r');
    set(p, 'MarkerSize', 10);
    
    
    %   Print to file
    print(fig, '-djpeg', File);
end    

end

function [FFX, FFY] = gradientField(M)
%gradient:  Calculate the gradient on a matrix M and ignore entries which
%           are infinitely large.
%
%   Input is a matrix M with a potential field and entries set to 'Inf'.
%   The infinite entries represent walls. This function generates a vector
%   field representing the field of M, ignoring all infinite entries.
%
%   This function is based on the gradient_special function used in the
%   base project.
[m, n] = size(M);

FX = zeros(m, n);
FY = zeros(m, n);
FFX = zeros(m ,n);
FFY = zeros(m, n);

%   Check every element of the input matrix.
for i = 1:m
    for j = 1:n
        %   Is M(i, j) part of the wall?
        if M(i, j) ~= Inf,
            %   Is M(i, j) on the border of the map?
            if j > 1 && j < n,
                %   M(i, j) is not on the border.
                %   Check the following cases:
                
                %   1. W�W
                if M(i, j - 1) == Inf && M(i, j + 1) == Inf,
                    FX(i, j) = 0;
                %   2. W��
                elseif M(i, j - 1) == Inf,
                    FX(i, j) = M(i, j) - M(i, j + 1);
                %   3. ��W
                elseif M(i, j + 1) == Inf,
                    FX(i, j) = M(i, j - 1) - M(i, j);
                %   4. ���
                else
                    FX(i, j) = 0.5*(M(i, j - 1) - M(i, j + 1));
                end
                
            elseif j > 1,
                %   M(i, j) is on the right border.
                %   Check the following cases:
                
                %   1. W�
                if M(i, j - 1) == Inf,
                    F(i, j) = 0;
                %   2. ��
                else
                    F(i, j) = M(i, j - 1) - M(i, j);
                end
                
            else
                %   M(i, j) is on the left border.
                %   Check the following cases:
                
                %   1. �W
                if M(i, j + 1) == Inf,
                    FX(i, j) = 0;
                %   2. ��
                else
                    FX(i, j) = M(i , j) - M(i, j + 1);
                end
            end
            
            %   is M(i, j) on the border of the map?
            if i > 1 && i < n,
                %   M(i, j) is not on the border.
                %   Check the following cases:
                
                %   1.  W
                %       �
                %       W
                if M(i - 1, j) == Inf && M(i + 1, j) == Inf,
                    FY(i, j) = 0;
                %   2.  W
                %       �
                %       �
                elseif M(i - 1, j) == Inf,
                    FY(i, j) = M(i, j) - M(i + 1, j);
                %   3.  �
                %       �
                %       W
                elseif M(i + 1, j) == Inf,
                    FY(i, j) = M(i - 1, j) - M(i, j);
                %   4.  �
                %       �
                %       �
                else
                    FY(i, j) = 0.5*(M(i - 1, j) - M(i + 1, j));
                end
            elseif i > 1,
                %   M(i, j) is on the bottom border.
                %   Check the following cases:
                
                %   1.  W
                %       �
                if M(i - 1, j) == Inf,
                    FY(i, j) = 0;
                %   2.  �
                %       �
                else
                    FY(i, j) = M(i - 1, j) - M(i, j);
                end
            else
                %   M(i, j) is on the top border.
                %   Check the following cases:
                
                %   1.  �
                %       W
                if M(i + 1, j) == Inf,
                    FY(i, j) = 0;
                %   2.  �
                %       �
                else
                    FY(i, j) = M(i, j) - M(i + 1, j);
                end
            end
        else
            %   M(i, j) is part of the wall.
            FX(i, j) = 0;
            FY(i, j) = 0;
        end        
        
        %   Normalize vector
        if FX(i, j) ~= 0 && FY(i, j) ~= 0,
            FFX(i, j) = FX(i, j)/(sqrt( FX(i, j)^2 + FY(i, j)^2 ));
            FFY(i, j) = FY(i, j)/(sqrt( FX(i, j)^2 + FY(i, j)^2 ));
        elseif FX(i, j) ~= 0,
            FFX(i, j) = FX(i, j)/abs( FX(i, j) );
            FFY(i, j) = 0;
        elseif FY(i, j) ~= 0,
            FFX(i, j) = 0;
            FFY(i, j) = FY(i, j)/abs( FY(i, j) );
        end
    end
end
end

