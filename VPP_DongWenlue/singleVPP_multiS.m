clear
clc

load sp
load spp
load wp
load wpp

T = 24;
S = 50;

% pro = spp(1 :5)';
% P1tMax = wp(1:5, :) * 1000; % 转化为 kw/h
% P2tMax = sp(1:5, :) * 1000;
pro = (wpp' * spp);
pro = pro(:);
P1stMax = wp * 1000; % 转化为 kw/h
P1stMax = repmat(P1stMax, [5 1]);
temp = sp(1:5, :) * 1000;
P2stMax = zeros(S,T);
for i = 1:5
    P2stMax(i*10-9: i*10, :) = repmat(temp(i, :), [10, 1]);
end

P1sMax = sum(P1stMax, 2);
P1sMin = P1sMax * (1 - 0.05);
P2sMax = sum(P2stMax, 2);
P2sMin = P2sMax * (1 - 0.05);

Vini = 1.43e8;      % m^3
VMax = 2.073e8; 
VMin = 2e7;
QMax = 42 * 3600;   % m^3/s
QMin = 3 * 3600;
J = 23.7 * 3600;    % m^3/s
A = 352.8 / 3600;   % A*Q kw/h

c1 = 0.61;
c2 = 1;
c3 = 0.2;

cp = 1.2;
cn = 0.5;

P1st = sdpvar(S, T);
P2st = sdpvar(S, T);
V = sdpvar(S, T+1);
Qst = sdpvar(S, T);
P0t = sdpvar(1, T);

dPt = (repmat(P0t,[S 1])- P1st - P2st - A * Qst);

f = pro' * sum((c1 * P1st + c2 * P2st + c3 * A * Qst  - (cp+cn)/2 * abs(dPt) + (cp-cn)/2 * dPt), 2);
%f = pro' * sum((c1 * P1t + c2 * P2t  - (la+ln)/2 * abs(dPt) + (la-ln)/2 * dPt), 2) + c3 * A * J * T;
% J * T = sum(Qt, 2);

F = [];
F = F + (0 <= P1st <= P1stMax) + (0 <= P2st <= P2stMax);       %(4)
F = F + (sum(P1st, 2) >= P1sMin);    % (5)
F = F + (sum(P2st, 2) >= P2sMin);    % (6)
% A * Qt = P3t
F = F + (VMin <= V <= VMax);    % (9)
F = F + (V(:, 1) == Vini) + (V(:, 25) == Vini);   % (10)
F = F + (QMin <= Qst <= QMax);   % (11)

for t = 1: T
    F = F + (V(:, t+1) == V(:, t) + J - Qst(:, t)); % (8) 
end

ops = sdpsettings('solver', 'lpsolve');
optimize(F, -f, ops);  % 解决最小化问题

double(f)
result = [];
result = [result; double(P1st)];
result = [result; double(P2st)];
result = [result; double(Qst) * A];
result = [result; double(P0t)];

figure(2);
plot([1: T], result(end,:));






