clear all
clc

A = 1;
c_versch = 0.5;
B = 0.72;

x = [0 : 0.01 : 1];

for i = 1 : length(x)
     f(i) = (A * exp((c_versch - x(i)) / B));
end

plot(x, f)
axis([0 x(end) 0 1])
xlabel('relative value')
ylabel('magnitude')