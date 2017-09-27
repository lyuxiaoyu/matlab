x = sdpvar(3, 1);
f = [4 2 1] * x;
F = (2*x(1) + x(2) <= 1);
F = F + ([1 0 2] * x <= 2);
F = F + (x(1) + x(2) + x(3) == 1);
F = F + (0 <= x(1) <= 1);
F = F + (0 <= x(2) <= 1);
F = F + (0 <= x(3) <= 2);
ops = sdpsettings('solver', 'lpsolve', 'verbose', 2);
result = solvesdp(F, -f, ops);
double(f)
double(x)
