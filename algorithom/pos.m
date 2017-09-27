clear
clc 
close all
tic

% fs = y * sin(2 * pi * x) + x * cos(2 * pi * y);
objfunc = @testfunc;
[~, fs] = objfunc([0,0]);

%% ����Ⱥ�㷨��ʼ��
genMax = 70;
trace = zeros(genMax, 1); %��¼
popsize = 40;       % ��������
w = 1;              % �ٶȹ��Բ���
c1 = 0.5;           % �ٶȸ��²�����������ʷ����
c2 = 0.1;           % �ٶȸ��²�����ȫ������
%��ʼ������λ��
lx = -2; ux = 2;    
ly = -2; uy = 2;
pop = zeros(popsize, 2);    
pop(:, 1) = rand([popsize 1]) * (ux - lx) + lx;
pop(:, 2) = rand([popsize 1]) * (uy - ly) + ly;
%��ʼ�������ٶ�
lxv = -0.8; uxv = 0.8;
lyv = -0.8; uyv = 0.8;
popV = zeros(popsize, 2);   
popV(:, 1) = rand([popsize 1]) * (uxv - lxv) + lxv;
popV(:, 2) = rand([popsize 1]) * (uyv - lyv) + lyv;
%��ʼ������
popRecord = pop;
fitnessRecord = objfunc(pop);
[bestFitness, bestIndex] = max(fitnessRecord); % �󼫴�ֵ

%% ��ʾ����ͼ��
figure(1);
ezmesh(fs, [lx, ux, ly, uy], 50);
hold on;
plot3(popRecord(bestIndex, 1),popRecord(bestIndex, 2), bestFitness, 'b*');
plot3(popRecord(: , 1),popRecord(: , 2), fitnessRecord, 'bo');
hold off;

%% ����Ⱥ�㷨
for gen = 1: genMax
    % �����ٶ�
    r1 = rand([popsize, 2]) * c1;
    r2 = rand([popsize, 2]) * c2;
    popV = w .* popV + r1 .* (popRecord - pop) + r2 .* (repmat(popRecord(bestIndex, :), [popsize, 1]) - pop);
    popV(popV(:, 1) < lxv, 1) = lxv;
    popV(popV(:, 1) > uxv, 1) = uxv;
    popV(popV(:, 2) < lyv, 2) = lyv;
    popV(popV(:, 2) > uyv, 2) = uyv;
    %����λ��
    pop = pop + popV;
    pop(pop(:, 1) < lx, 1) = lx;
    pop(pop(:, 1) > ux, 1) = ux;
    pop(pop(:, 2) < ly, 2) = ly;
    pop(pop(:, 2) > uy, 2) = uy;
    %���¸�����ʷ����
    fitness = objfunc(pop);
    betterIndex = find(fitnessRecord < fitness);
    fitnessRecord(betterIndex) = fitness(betterIndex);
    popRecord(betterIndex, :) = pop(betterIndex, :);
    %����ȫ������
    [tmpFitness, tmpIndex] = max(fitnessRecord); % �󼫴�ֵ
    if bestFitness < tmpFitness
        bestFitness = tmpFitness;
        bestIndex = tmpIndex;
        %%������ʾ
%         figure(gen);
%         ezmesh(fs, [lx, ux, ly, uy], 50);
%         hold on;
%         plot3(popRecord(bestIndex, 1),popRecord(bestIndex, 2), bestFitness, 'b*');
%         plot3(popRecord(: , 1),popRecord(: , 2), fitness, 'bo');
%         hold off
    end
    trace(gen, 1) =  bestFitness;
    
    %% ��̬������ʾ
    ezmesh(fs, [lx, ux, ly, uy], 50);
    hold on 
    plot3(popRecord(bestIndex, 1),popRecord(bestIndex, 2), bestFitness, 'b*');
    plot3(pop(: , 1),pop(: , 2), fitness, 'bo');
    hold off
    pause(0.2);
end
%% �����ʾ
figure(genMax+1);
plot(1: genMax, trace(:, 1)');

display([popRecord(bestIndex, 1),popRecord(bestIndex, 2), bestFitness]);

disp(toc);