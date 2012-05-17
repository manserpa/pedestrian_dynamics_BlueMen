clear all
clc

A = 0.1;
c_versch = 1.005;
B = 1;
C = 10.3;

x = [0 : 0.01 : 1];

for i = 1 : length(x)
     f(i) = (A * (log((c_versch - x(i)) / B) + C));
end

plot(x, f)
axis([0 x(end) 0 1])
xlabel('relative value')
ylabel('magnitude')