% Visualization of exponential character of the wall force for the project report

clear all
clc

c_wall = 1.2;
weight_fwall = 100;
A_wall = 150;
r = 3 - c_wall;
B_wall = 2;
n = 1;

d = [0 : 0.1 : 10];

for i = 1 : length(d)
     f(i) = weight_fwall * (A_wall * exp((r - d(i)) / B_wall) * n); % Betrag der Kraft
end

plot(d, f)
axis([0 d(end) 0 20000])
xlabel('distance between pedestrian and wall')
ylabel('magnitude of force')