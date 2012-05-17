clear all
clc

% A = -0.22;
% c_versch = 1.03;
% B = 0.43;
% C = -0.2;

x = [0 : 0.01 : 1];

for i = 1 : length(x)
     f(i) = 1.5 * (x(i) - 0.5);
end

plot(x, f)
axis([0 x(end) 0 1])
xlabel('relative value')
ylabel('magnitude')