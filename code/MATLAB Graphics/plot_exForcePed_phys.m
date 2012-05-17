% Visualization of exponential character of the wall force for the project report

clear all
clc

weight_fsoc = 0.1;
A_phys = 300;
r = 7.5;
B_phys = 0.5;
n = 1;

d = [0 : 0.1 : 16];

for i = 1 : length(d)
     f(i) = weight_fsoc * (A_phys * exp((r - d(i)) / B_phys) * n); % Betrag der Kraft
end

plot(d, f)
axis([0 d(end) 0 800])
xlabel('distance between pedestrian and wall')
ylabel('magnitude of force')