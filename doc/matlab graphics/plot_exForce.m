% Visualization of exponential character of the pedestrian interaction force for the project report

clear all
clc

A_1 = 80;
r = 0.6;
B_1 = 1;
n = 1;
lambda = 0.2;
A_2 = 40;
B_2 = 2;
phi = 0;

d = [0 : 0.1 : 10];

for i = 1 : length(d)
     f(i) = A_1 * exp((r - d(i)) / B_1) * n * (lambda + (1 - lambda) * ((1 + cos(phi)) / 2)) + A_2 * exp((r - d(i)) / B_2) * n; % Betrag der Kraft
end

plot(d, f)
axis([0 d(end) 0 150])
xlabel('distance between two pedestrians')
ylabel('magnitude of force')