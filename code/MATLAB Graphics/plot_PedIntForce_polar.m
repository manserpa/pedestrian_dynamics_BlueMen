% Visualization of the pedestrian interaction force for the project report

clear all
clc

weight_fsoc = 0.1;
A_anisotrop = 1000;
r = 7.8;
B_anisotrop = 5;
n = 1;
lambda = 0.1;
A_phys = 300;
B_phys = 0.5;

d = [7 10 16];
phi = 0 : (pi / 50) : (2 * pi);

for j = 1 : length(d)
    for i = 1 : length(phi)
        f(j, i) = A_anisotrop * exp((r - d(j)) / B_anisotrop) * n * (lambda + (1 - lambda) * ((1 + cos(phi(i))) / 2)) + A_phys * exp((r - d(j)) / B_phys) * n;   % ACHTUNG: Dies ist nur der Betrag der Kraft
    end
    polar(phi, f(j,:))
    hold on
end

legend('d=7', 'd=10', 'd=16', 'Location', 'BestOutside')