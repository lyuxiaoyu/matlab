
%% optimtool('ga');

function f = gadst_func(x)
    f1 = 4 * x(1).^3 + 4 * x(1) * x(2) + 2 * x(2).^2 - 42 * x(1) - 14;
    f2 = 4 * x(2).^3 + 4 * x(1) * x(2) + 2 * x(1).^2 - 26 * x(1) - 22;
    f = f1.^2 + f2.^2;
end