% Visualization of the pedestrian interaction force for the project report

clear all
clc

mtopix = 10;

A_soc = 20 * mtopix;
r = 0.6 * mtopix;
B_soc = 5;
n = 1;
lambda = 0.2;
A_phys = 30 * mtopix;
B_phys = 5;

d = [10 20 30];
phi = 0 : (pi / 50) : (2 * pi);

for j = 1 : length(d)
    for i = 1 : length(phi)
        f(j, i) = A_soc * exp((r - d(j)) / B_soc) * n * (lambda + (1 - lambda) * ((1 + cos(phi(i))) / 2)) + A_phys * exp((r - d(j)) / B_phys) * n;   % ACHTUNG: Dies ist nur der Betrag der Kraft
    end
    polar(phi, f(j,:))
    hold on
end

legend('d=10', 'd=20', 'd=30', 'Location', 'BestOutside')