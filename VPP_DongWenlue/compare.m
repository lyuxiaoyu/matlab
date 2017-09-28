clear
clc

load sampleData

T = 24;
S = 50;
% 本程序中，行为每一场景，列为时间

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

cto = ones(1,24) * 0.59; % 峰谷电价
cto(1: 7) = 0.26;   
cto(17: 21) = 0.92;

c1 = 0.61;          % 风
c2 = 1;             % 光
c3 = 0.2;           % 水

cp = 1.2;           % 备用电价
cn = 0.5;

P1st = sdpvar(S, T);
P2st = sdpvar(S, T);
V = sdpvar(S, T+1);
Qst = sdpvar(S, T);
P0t = sdpvar(1, T);

dPt = (repmat(P0t,[S 1])- P1st - P2st - A * Qst);
cpnc1 = (cp + cn - cto)/2;   % 这里的电价与时间有关，所以为矩阵
cpnc2 = (cp - cn + cto)/2;  

% objectFunc
f1 = pro' * sum((c1 * P1st + c2 * P2st + c3 * A * Qst  - (cp+cn)/2 * abs(dPt) - (cp-cn)/2 * dPt), 2);
f2 = Lt * cto' - P0t * cto' + pro' * (abs(dPt) * cpnc1' +  dPt * cpnc2');

ops = sdpsettings('solver', 'bnb');

for i = 1: 20
    J = i * 2 * 3600;
    
    % S.T.
    F = [];
    F = F + (0 <= P1st <= P1stMax) + (0 <= P2st <= P2stMax);       %(4)
    F = F + (sum(P1st, 2) >= P1sMin);    % (5)
    F = F + (sum(P2st, 2) >= P2sMin);    % (6)
    % A * Qt = P3t  %(7)
    F = F + (VMin <= V <= VMax);    % (9)
    F = F + (V(:, 1) == Vini) + (V(:, 25) == Vini);   % (10)
    F = F + (QMin <= Qst <= QMax);   % (11)
    for t = 1: T
        F = F + (V(:, t+1) == V(:, t) + J - Qst(:, t)); % (8) 
    end
    
    % Vpp个体利润最大化
    optimize(F, -f1, ops);  
    
    result1.backup(i) = double(pro' * sum(((cp+cn)/2 * abs(dPt) + (cp-cn)/2 * dPt),2));
    result1.VppSellProfit(i) = double(pro' * sum((c1 * P1st + c2 * P2st + c3 * Qst * A), 2));
    result1.VppNetProfit(i) = result1.VppSellProfit(i) - result1.backup(i);
    result1.OtherSellProfit(i) = double(cto * (Lt - pro' * (P1st + P2st + Qst * A))');
    result1.OtherNetProfit(i) = result1.OtherSellProfit(i) + result1.backup(i);
    result1.DCExpense(i) = result1.VppNetProfit(i) + result1.OtherNetProfit(i);
    
     % 传统电场利润最小化
    optimize(F, f2, ops); 
    
    result2.backup(i) = double(pro' * sum(((cp+cn)/2 * abs(dPt) + (cp-cn)/2 * dPt),2));
    result2.VppSellProfit(i) = double(pro' * sum((c1 * P1st + c2 * P2st + c3 * Qst * A), 2));
    result2.VppNetProfit(i) = result2.VppSellProfit(i) - result2.backup(i);
    result2.OtherSellProfit(i) = double(cto * (Lt - pro' * (P1st + P2st + Qst * A))');
    result2.OtherNetProfit(i) = result2.OtherSellProfit(i) + result2.backup(i);
    result2.DCExpense(i) = result2.VppNetProfit(i) + result2.OtherNetProfit(i);
    
    fprintf('iter = %d', i);
    display(result1);
    display(result2);
end






