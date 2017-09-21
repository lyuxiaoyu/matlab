clear
clc
close all

% 集合操作setdiff真的是慢
co = rand(100,2);

dist = caculatedist(co);
pointNum = size(co, 1);
antNum = 40;
iterMax = 150;
a = 1;              % 信息素权重系数
b = 4;              % 启发系数
q = 0.1;            % 信息数衰退系数
Q = 0.1 / antNum;           % 每次的信息数总量
pathQ = zeros(pointNum) + 1;    % 每条边上的信息素量
pathWeight = zeros(pointNum);   % 每条边的权重
bestPath = zeros(1, pointNum -1);
bestPathLen = inf;
trace = zeros(iterMax, 1);

tic
for iter = 1: iterMax
    pathWeight = (pathQ .^ a) .* (dist .^ (-1 * b));
    pathQ = pathQ * (1 -q); % 信息素衰退
    
    bestCurrPath = zeros(1, pointNum -1);
    bestCurrPathLen = inf;
    for j = 1: antNum
        % 规划 蚂蚁路径
        antPath = zeros(1, pointNum -1);
        remainPoint = 2: pointNum;
        [newpoint, remainPoint] = choosePoint(1, remainPoint, pathWeight); % 根据pathWeight，概率选择下一节点
        antPath(1, 1) = newpoint; 
        for k = 2: pointNum -1
            [newpoint, remainPoint] = choosePoint(newpoint, remainPoint, pathWeight); % 根据pathWeight，概率选择下一节点
            antPath(1, k) = newpoint; 
        end
        % 更新 路径信息素
        antPathLen = pathlength(antPath, dist);
        pathQ = addPathQ(pathQ, antPath, Q / antPathLen);
        % 保存 本次蚁群最优解
        if bestCurrPathLen > antPathLen
            bestCurrPathLen = antPathLen;
            bestCurrPath = antPath;
        end
    end
    % 保存 历史最优解
    if bestPathLen > bestCurrPathLen
        bestPathLen = bestCurrPathLen;
        bestPath = bestCurrPath;
    end
    trace(iter,1) = bestPathLen;
end

drawpath(co, [1 bestPath], 1);
figure(2);
plot(1:iterMax, trace);

display(toc);
