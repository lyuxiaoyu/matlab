%% y .* sin(2 * pi * x) + x .* cos(2 * pi * y)

function [f, fs] = testfunc(pop)
    x = pop(:, 1);
    y = pop(:, 2);
    f = y .* sin(2 * pi * x) + x .* cos(2 * pi * y);
    fs = 'y .* sin(2 * pi * x) + x .* cos(2 * pi * y)';
end