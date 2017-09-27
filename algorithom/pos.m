clear
clc 
close all
tic

% fs = y * sin(2 * pi * x) + x * cos(2 * pi * y);
objfunc = @testfunc;
[~, fs] = objfunc([0,0]);

%% 粒子群算法初始化
genMax = 70;
trace = zeros(genMax, 1); %记录
popsize = 40;       % 粒子数量
w = 1;              % 速度惯性参数
c1 = 0.5;           % 速度更新参数，个人历史最优
c2 = 0.1;           % 速度更新参数，全局最优
%初始化粒子位置
lx = -2; ux = 2;    
ly = -2; uy = 2;
pop = zeros(popsize, 2);    
pop(:, 1) = rand([popsize 1]) * (ux - lx) + lx;
pop(:, 2) = rand([popsize 1]) * (uy - ly) + ly;
%初始化粒子速度
lxv = -0.8; uxv = 0.8;
lyv = -0.8; uyv = 0.8;
popV = zeros(popsize, 2);   
popV(:, 1) = rand([popsize 1]) * (uxv - lxv) + lxv;
popV(:, 2) = rand([popsize 1]) * (uyv - lyv) + lyv;
%初始化最优
popRecord = pop;
fitnessRecord = objfunc(pop);
[bestFitness, bestIndex] = max(fitnessRecord); % 求极大值

%% 显示函数图像
figure(1);
ezmesh(fs, [lx, ux, ly, uy], 50);
hold on;
plot3(popRecord(bestIndex, 1),popRecord(bestIndex, 2), bestFitness, 'b*');
plot3(popRecord(: , 1),popRecord(: , 2), fitnessRecord, 'bo');
hold off;

%% 粒子群算法
for gen = 1: genMax
    % 更新速度
    r1 = rand([popsize, 2]) * c1;
    r2 = rand([popsize, 2]) * c2;
    popV = w .* popV + r1 .* (popRecord - pop) + r2 .* (repmat(popRecord(bestIndex, :), [popsize, 1]) - pop);
    popV(popV(:, 1) < lxv, 1) = lxv;
    popV(popV(:, 1) > uxv, 1) = uxv;
    popV(popV(:, 2) < lyv, 2) = lyv;
    popV(popV(:, 2) > uyv, 2) = uyv;
    %更新位置
    pop = pop + popV;
    pop(pop(:, 1) < lx, 1) = lx;
    pop(pop(:, 1) > ux, 1) = ux;
    pop(pop(:, 2) < ly, 2) = ly;
    pop(pop(:, 2) > uy, 2) = uy;
    %更新个体历史最优
    fitness = objfunc(pop);
    betterIndex = find(fitnessRecord < fitness);
    fitnessRecord(betterIndex) = fitness(betterIndex);
    popRecord(betterIndex, :) = pop(betterIndex, :);
    %更新全体最优
    [tmpFitness, tmpIndex] = max(fitnessRecord); % 求极大值
    if bestFitness < tmpFitness
        bestFitness = tmpFitness;
        bestIndex = tmpIndex;
        %%过程显示
%         figure(gen);
%         ezmesh(fs, [lx, ux, ly, uy], 50);
%         hold on;
%         plot3(popRecord(bestIndex, 1),popRecord(bestIndex, 2), bestFitness, 'b*');
%         plot3(popRecord(: , 1),popRecord(: , 2), fitness, 'bo');
%         hold off
    end
    trace(gen, 1) =  bestFitness;
    
    %% 动态过程显示
    ezmesh(fs, [lx, ux, ly, uy], 50);
    hold on 
    plot3(popRecord(bestIndex, 1),popRecord(bestIndex, 2), bestFitness, 'b*');
    plot3(pop(: , 1),pop(: , 2), fitness, 'bo');
    hold off
    pause(0.2);
end
%% 结果显示
figure(genMax+1);
plot(1: genMax, trace(:, 1)');

display([popRecord(bestIndex, 1),popRecord(bestIndex, 2), bestFitness]);

disp(toc);