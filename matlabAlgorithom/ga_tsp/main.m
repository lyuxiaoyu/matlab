clear
clc
close all

% co = [16.47 96.10; 
%     16.47 94.44; 
%     24.09 92.54; 
%     22.39 93.37;
%     25.23 97.24; 
%     22.00 96.05; 
%     20.47 97.02; 
%     17.20 96.29;
%     16.30 97.38; 
%     14.05 98.12; 
%     16.53 97.38; 
%     21.52 95.59;
%     19.41 97.13; 
%     20.09 92.55];
% drawpath(co, [1 randperm(size(co,1)-1)+1], 1);
co = rand(100,2);

dist = caculatedist(co);
NIND = 60;
MAXGEN = 1200;
PRECI = size(co, 1) -1;
GGAP = 0.95;
px = 0.7;
pm = 0.1;
trace = cell(MAXGEN,3);
chrom = initpop(NIND, PRECI);   
objV = pathlength(chrom, dist); 

tic
for gen = 1: MAXGEN
    fit = fitness(objV);                    % 计算适应度,线性
    selCh = chselect(chrom, fit, GGAP);     % 选择,推
    selCh = chrecombin(selCh, px);          % 配对重组,单点
    selCh = chmut(selCh, pm + (1 - pm) * gen / MAXGEN);               % 变异
    objVSel = pathlength(selCh, dist);       
    [chrom, objV] = chreins(chrom, selCh, objV, objVSel); % 形成新种群,已从优到劣排序
    
    trace(gen, 1) = {chrom(1, :)};
    trace(gen, 2) = {objV(1)};
    trace(gen, 3) = {mean(objV)};
    
%     if mod(gen - 1, MAXGEN/10) == 0
%         drawpath(co, [1,chrom(1, :), 1], gen);
%     end
end
drawpath(co, [1,chrom(1, :), 1], gen);

figure(gen + 1)
plot(1:MAXGEN, [trace{:, 2}], 1:MAXGEN, [trace{:, 3}]);
legend('best','mean');

display(toc)