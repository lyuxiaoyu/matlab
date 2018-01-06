
fileName = "data.xlsx";

T = 24;
S = 10;
oder = 1;

% 电价
% cto = ones(1,T) * 0.59; % 峰谷电价
% cto(1: 7) = 0.31;   
% cto(17: 21) = 0.92;
alpha = 1;
cp = 1.2;
cn = 0.4;
c1 = ones(1,T) * 0.61;  % 新能源价格
clt = ones(1,T) * 0.61; % 对内售电价格
cb = clt * 1.2;         % 向外购电价格

% 需求响应
u = 0.001;              % 元/(kwh * kwh)  % 需求舒适度，补偿系数 

% 负荷
PL = xlsread(fileName, oder + 1, "C16: Z16") * 1000 + 500;  % 1 * T  % kw

% 风电数据
pro1 = xlsread(fileName, oder + 1, "B5: B14");
P1stMax = xlsread(fileName, oder + 1, "C5: Z14") * 1000; % mk转化为 kw
P1sMax = sum(P1stMax, 2);
P1sMin = P1sMax * (1 - 0.05);

% 电池
E1ini = xlsread(fileName, oder + 1, "C3");
E1Max = xlsread(fileName, oder + 1, "D3");
E1Min = 0;
Q1Max = xlsread(fileName, oder + 1, "E3");
Q1Min = xlsread(fileName, oder + 1, "F3");


% 初始化变量
P1st = sdpvar(S, T);
E1st = sdpvar(S, T+1);
Q1st = sdpvar(S, T);
P0t = sdpvar(1, T);
P1Lst = sdpvar(S, T);
dPLst = sdpvar(S, T);


% 目标函数
Pb = repmat(PL,[S 1]) + dPLst - P1Lst;      %   负荷平衡
dPt = repmat(P0t,[S 1]) - (P1st + Q1st - dPLst - repmat(PL,[S 1]));     % 误报量
ps = sum((cp+cn)/2 * abs(dPt) + (cp-cn)/2 * dPt, 2);                    % 误报量惩罚
ds = sum(dPLst .^ 2 * u, 2);                                        % 需求响应补偿
rs = (P1st + Q1st) * c1' + P1Lst * (clt - c1)' - Pb * (cb - clt)';      % 购电售电收益
f =  pro1' * (rs - ps - ds);                                            % 最终目标，多场景计算

% 约束
F = [];
F = F + (0 <= P1Lst <= P1st + Q1st);        % 新能源内售电量约束
F = F + (P1Lst <= repmat(PL,[S 1]) + dPLst);

F = F + (dPLst <= repmat(PL,[S 1]) * 0.1);  % 负荷需求响应约束
F = F + (dPLst >= -repmat(PL,[S 1]) * 0.1);
F = F + (sum(dPLst, 2) == zeros(S, 1));
for t = 1: T - 1
    F = F + (abs(dPLst(:, t)) / PL(t) +  abs(dPLst(:, t + 1)) / PL(t + 1) <= 0.08);
end

F = F + (0 <= P1st <= P1stMax);      % 风电约束
F = F + (sum(P1st, 2) >= P1sMin);    % 

F = F + (E1Min <= E1st <= E1Max);    % 储能约束
F = F + (E1st(:, 1) == E1ini) + (E1st(:, 25) == E1ini);   % 
F = F + (Q1Min <= Q1st <= Q1Max);   % 
for t = 1: T
    F = F + (E1st(:, t+1) == E1st(:, t) - Q1st(:, t)); % 
end


ops = sdpsettings('solver', 'mosek');
optimize(F, -f, ops);  % 解决最小化问题

% 结果
result.Object = double(f);
result.P1st = double(P1st);
result.E1st = double(E1st);
result.Q1st = double(Q1st);
result.P1Lst = double(P1Lst);
result.Pb = double(Pb);
result.P0t = double(P0t);

display(result.Object);

s = 3;
plot(1:24, result.P1st(s, :) + result.Q1st(s, :) ... 
, 1:24, result.P0t ...
, 1:24, result.P1st(s, :) + result.Q1st(s, :) - double(P1Lst(s, :)) - result.Pb(s, :) ...
, 1:24, result.Pb(s, :) ...
, 1:24, PL ...
, 1:24, double(dPLst(s, :)) + PL...
);

