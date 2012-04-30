% Visualization of the pedestrian interaction force for the project report

clear all
clc

A_i1 = 80;
r_ij = 0.6;
d_ij = 2;
B_i1 = 1;
n_ij = [1 0]';
lambda_i = 0.2;
A_i2 = 40;
B_i2 = 2;

phi = 0 : (pi / 50) : (2 * pi);
f_ij = zeros(length(n_ij), length(phi));

for i = 1 : length(phi)
    f_ij(:, i) = A_i1 * exp((r_ij - d_ij) / B_i1) * n_ij * (lambda_i + (1 - lambda_i) * ((1 + cos(phi(i))) / 2)) + A_i2 * exp((r_ij - d_ij) / B_i2) * n_ij;
    f_ij_betrag(1, i) = norm(f_ij(:, i));
end

plot(phi, f_ij_betrag)

axis([0 2*pi 0 40])
xlabel('phi')
ylabel('force')