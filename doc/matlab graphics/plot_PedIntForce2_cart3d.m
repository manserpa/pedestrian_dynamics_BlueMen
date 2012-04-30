% Visualization of the pedestrian interaction force for the project report

clear all
clc

A_i1 = 80;
r_ij = 0.6;
B_i1 = 1;
lambda_i = 0.2;
A_i2 = 40;
B_i2 = 2;

x = [-2 : 0.01 : 2];
y = [-2 : 0.01 : 2];
force = zeros(length(x), length(y));
d = zeros(length(x), length(y));
phi = zeros(length(x), length(y));
n_x = zeros(1, length(x));
n_y = zeros(1, length(y));
e = [0 1]'; % direction of movement

for i = 1 : length(x)
    for j = 1 : length(y)
        
        d(i, j) = sqrt(x(i)^2 + y(j)^2);    % distance between point (i,j) and (0,0)
        n_x(1, i) = x(i); % x-distance from 0 to i
        n_y(1, j) = y(j); % x-distance from 0 to j
        phi(i, j) = acos(dot(-[n_x(i) n_y(j)]', e));
        
        force(i, j) = norm(A_i1 * exp((r_ij - d(i, j)) / B_i1) * [n_x(i) n_y(j)]' * (lambda_i + (1 - lambda_i) * ((1 + cos(phi(i, j))) / 2)) + A_i2 * exp((r_ij - d(i, j)) / B_i2) * [n_x(i) n_y(j)]');
        
    end
end

plot(force)
xlabel('x')
ylabel('y')
zlabel('z')