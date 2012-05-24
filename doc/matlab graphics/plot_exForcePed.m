% Visualization of exponential character of the pedestrian interaction force for the project report

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
phi = 0;

d = [0 : 0.1 : 100];

for i = 1 : length(d)
     f(i) = A_soc * exp((r - d(i)) / B_soc) * n * (lambda + (1 - lambda) * ((1 + cos(phi)) / 2)) + A_phys * exp((r - d(i)) / B_phys) * n; % Betrag der Kraft
end

plot(d, f)
axis([0 d(end) 0 500])
xlabel('distance between two pedestrians')
ylabel('magnitude of force')