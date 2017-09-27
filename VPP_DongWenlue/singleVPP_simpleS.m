clear
clc

load sp
load spp
load wp
load wpp

P1tMax = wp(1, :) * 1000; % 转化为 kw/h
P2tMax = sp(1, :) * 1000;

P1Max = sum(P1tMax);
P1Min = P1Max * (1 - 0.5);
P2Max = sum(P2tMax);
P2Min = P2Max * (1 - 0.5);

Vini = 1.43e8;      % m^3
VMax = 2.073e8; 
VMin = 2e7;
QMax = 42 * 3600;   % m^3/h
QMin = 3 * 3600;
J = 23.7 * 3600;    % m^3/h
A = 352.8 / 1000;   % A*Q kw/h

c1 = 0.61;
c2 = 1;
c3 = 0.2;

la = 1.2;
ln = 0.5;

T = 24;
P1t = sdpvar(1, T);
P2t = sdpvar(1, T);
V = sdpvar(1, T+1);
Qt = sdpvar(1, T);
P0t = sdpvar(1, T);

dPt = (P0t - P1t - P2t - A * Qt);

f = c1 * sum(P1t) + c2 * sum(P2t) + c3 * A * J * T - sum((la+ln)/2 * abs(dPt) + (la-ln)/2 * dPt) ;
% J * T = sum(Qt);

F = [];
F = F + (sum(P1t) >= P1Min);    % (5)
F = F + (sum(P2t) >= P2Min);    % (6)
F = F + (V(1) == Vini) + (V(25) == Vini);   % (10)
F = F + (VMin <= V <= VMax);    % (9)
F = F + (QMin <= Qt <= QMax);   % (11)
for t = 1: T
    F = F + (0 <= P1t(t) <= P1tMax(t)) + (0 <= P2t(t) <= P2tMax(t));    %(4)
    F = F + (V(t+1) == V(t) + J - Qt(t)); % (8) 
end

ops = sdpsettings('solver', 'bnb');
optimize(F, -f, ops);  % solvesdp解决最小化问题

double(f);
result = [];
result = [result; double(P1t)];
result = [result; double(P2t)];
result = [result; double(Qt) * A];
result = [result; double(P0t)];









