% Visualization of exponential character of the pedestrian interaction force for the project report

clear all
clc

weight_soc = 1;
c_soc = 7;
A_soc = 1000;
r = 6 + c_soc;
B_soc = 5;
n = 1;
lambda = 0.3;
A_phys = 300;
B_phys = 2;
phi = 0;

d = [0 : 0.1 : 20];

for i = 1 : length(d)
     f(i) = A_soc * exp((r - d(i)) / B_soc) * n * (lambda + (1 - lambda) * ((1 + cos(phi)) / 2)) + A_phys * exp((r - d(i)) / B_phys) * n; % Betrag der Kraft
end

plot(d, f)
axis([0 d(end) 0 20000])
xlabel('distance between two pedestrians')
ylabel('magnitude of force')