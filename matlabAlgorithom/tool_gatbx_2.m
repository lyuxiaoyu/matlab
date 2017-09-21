clear
clc 
close all

%fs = y * sin(2 * pi * x) + x * cos(2 * pi * y)
[~, fs] = testfunc([0,0]);
%% 显示函数图像
figure(1);
lbx = -2;
ubx = 2;
lby = -2;
uby = 2;
ezmesh(fs, [lbx, ubx, lby, uby], 50);
hold on;

%% 遗传算法初始化
NIND = 40;
MAXGEN = 100;
PRECI = 20;
GGAP = 0.95;
px = 0.7;
pm = 0.1;
trace = zeros(3, MAXGEN);
fieldD = [PRECI PRECI; lbx lby; ubx uby; 1 1; 0 0; 1 1; 1 1];
chrom = crtbp(NIND, PRECI * 2);

%% 遗传算法
gen = 0;
xy = bs2rv(chrom, fieldD);
objV = -testfunc(xy);
while gen < MAXGEN
    gen = gen + 1;
    fitnV = ranking(objV);
    selCh = select('sus', chrom, fitnV, GGAP);
    selCh = recombin('xovsp', selCh, px);
    selCh = mut(selCh, pm);
    xy = bs2rv(selCh, fieldD);
    objVSel = -testfunc(xy);
    [chrom, objV] = reins(chrom, selCh, 1, 1, objV, objVSel);
    xy = bs2rv(chrom, fieldD);
    [Y, I] = min(objV);
    trace(1: 2, gen) = xy(I, :);
    trace(3, gen) = Y;
end

%% 结果显示
plot3(trace(1, :), trace(2, :), -trace(3, :), 'b*');
grid on;
plot3(xy(:, 1), xy(:, 2), -objV, 'bo');          %最后一次
hold off;

figure(2);
plot(1: MAXGEN, -trace(3, :));

display(-trace(3, end));