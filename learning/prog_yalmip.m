% % Max z=x1^2+x2^2+3*x3^2+4*x4^2+2*x5^2-8*x1-2*x2-3*x3-x4-2*x5  
% % s.t.  
% % 0<=xi<=99(i=1,2,...,5)  
% % x1+x2+x3+x4+x5<=400  
% % x1+2*x2+2*x3+x4+6*x5<=800  
% % 2*x1+x2+6*x3<=800  
% % x3+x4+5*x5<=200  

clc
clear

x = sdpvar(5, 1);  % 产生变量
f = [1 1 3 4 2] * (x .^ 2) - [8 2 3 1 2] * x; % 目标函数
F = (0 <= x <= 100);   % 约束条件
F = F + ([1 1 1 1 1] * x <= 400); 
F = F + ([1 2 2 1 6] * x <= 800);
F = F + (2 * x(1) + x(2) + 6 * x(3) <= 800);  
F = F + (x(3) + x(4) + 5 * x(5) <= 200);
% ops default
ops = sdpsettings('solver', 'bmibnb', 'verbose', 2);
solvesdp(F, -f, ops);  % solvesdp解决最小化问题
double(f);    % 显示结果
double(x);
 


