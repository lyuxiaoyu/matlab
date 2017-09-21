clear
clc

%% 目标函数图像
lb = 1;
ub = 2;
figure(1);
hold on;
ezplot('sin(10*pi*X)/X', [lb,ub]); % 获取最小值
xlabel('X');
ylabel('Y');

%% 遗传算法初始化
NIND = 40;
MAXGEN = 20;
PRECI = 20;
GGAP = 0.95;
px = 0.7;
pm = 0.01;
trace = zeros(2, MAXGEN);
fieldD = [PRECI; lb; ub; 1; 0; 1; 1];
chrom = crtbp(NIND, PRECI);

%% 遗传算法
gen = 0;
x = bs2rv(chrom, fieldD);
objv = sin(10 * pi * x) ./ x;
while gen < MAXGEN
    gen = gen +1;
    fitnV = ranking(objv);                      % 适应度值
    selCh = select('sus', chrom, fitnV, GGAP);  % 选择
    selCh = recombin('xovsp', selCh, px);       % 交叉重组
    selCh = mut(selCh, pm);                     % 变异
    x = bs2rv(selCh, fieldD);                   % 解码
    objvSel = sin(10 * pi * x) ./ x;            % 计算子代目标函数值
    [chrom, objv] = reins(chrom, selCh, 1, 1, objv, objvSel);        % 结合子代和父代得到新种群
    x = bs2rv(chrom, fieldD);                   % 解码
    [y, index] = min(objv);                     % 保存每代最优解
    trace(1, gen) = x(index);
    trace(2, gen) = y;
end

%% 结果表示
plot(trace(1, :), trace(2, :), 'bo');           % 每代最优值，在原图像上表示
grid on;
plot(x, objv, 'b*');                            % 最后种群
hold off;
figure(2);
plot(1:MAXGEN, trace(2, :));                    % 每代最优值
xlabel('遗传代数');
ylabel('每代最优解');


