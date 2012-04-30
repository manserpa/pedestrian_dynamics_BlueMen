% Visualization of the pedestrian interaction force for the project report

clear all
clc

A_1 = 80;
r = 0.6;
B_1 = 1;
n = 1;
lambda = 0.2;
A_2 = 40;
B_2 = 2;

d = [1 2 3];
phi = 0 : (pi / 50) : (2 * pi);

for j = 1 : length(d)
    for i = 1 : length(phi)
        f(j, i) = A_1 * exp((r - d(j)) / B_1) * n * (lambda + (1 - lambda) * ((1 + cos(phi(i))) / 2)) + A_2 * exp((r - d(j)) / B_2) * n;   % ACHTUNG: Dies ist nur der Betrag der Kraft
    end
    polar(phi, f(j,:))
    hold on
end

legend('d=1', 'd=2', 'd=3', 'Location', 'BestOutside')