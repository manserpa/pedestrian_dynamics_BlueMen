clear all
clc

A = -0.22;
c_versch = 1.03;
B = 0.43;
C = -0.2;

x = [0 : 0.01 : 1];

for i = 1 : length(x)
     f(i) = (A * (log((c_versch - x(i)) / B) + C));
end

plot(x, f)
axis([0 x(end) 0 1])
xlabel('relative value')
ylabel('magnitude')