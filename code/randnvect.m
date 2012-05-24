function [y] = randnvect(number, deviation, center)
%RANDVECT Vector with random values around center
%   number: quantity of returned values in vector (number,1)
%   deviation: deviation of the random values (not mathematically correct!)
%   center: middlepoint of the random values

y = randn(number,1)*deviation + center;

% set a limit for the maximum and the minimum just so no negative and not
% to high numbers are generated
for i = 1 : number
    if y(i) < center/2
        y(i) = center/2;
    elseif y(i) > center * (3/2)
        y(i) = center * (3/2);
    end
end

end

