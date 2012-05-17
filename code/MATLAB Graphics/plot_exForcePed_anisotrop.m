% Visualization of exponential character of the wall force for the project report

clear all
clc

weight_fsoc = 0.1;
A_anisotrop = 1000;
r = 7.8
B_anisotrop = 5;
n = 1;

d = [0 : 0.1 : 16];

for i = 1 : length(d)
     f(i) = weight_fsoc * (A_anisotrop * exp((r - d(i)) / B_anisotrop) * n); % Betrag der Kraft
end

plot(d, f)
axis([6 d(end) 0 400])
xlabel('distance between pedestrian and wall')
ylabel('magnitude of force')