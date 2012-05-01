% Visualization of exponential character of the wall force for the project report

clear all
clc

mtopix = 10;

A_wall = 15 * mtopix;
r = 0.3 * mtopix;
B_wall = 0.2 * mtopix;
n = 1;

d = [0 : 0.1 : 40];

for i = 1 : length(d)
     f(i) = A_wall * exp((r - d(i)) / B_wall) * n; % Betrag der Kraft
end

plot(d, f)
axis([0 d(end) 0 200])
xlabel('distance between pedestrian and wall')
ylabel('magnitude of force')