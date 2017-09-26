clear
clc
close all

% ���ϲ���setdiff�������
co = rand(100,2);

dist = caculatedist(co);
pointNum = size(co, 1);
antNum = 40;
iterMax = 150;
a = 1;              % ��Ϣ��Ȩ��ϵ��
b = 4;              % ����ϵ��
q = 0.1;            % ��Ϣ��˥��ϵ��
Q = 0.1 / antNum;           % ÿ�ε���Ϣ������
pathQ = zeros(pointNum) + 1;    % ÿ�����ϵ���Ϣ����
pathWeight = zeros(pointNum);   % ÿ���ߵ�Ȩ��
bestPath = zeros(1, pointNum -1);
bestPathLen = inf;
trace = zeros(iterMax, 1);

tic
for iter = 1: iterMax
    pathWeight = (pathQ .^ a) .* (dist .^ (-1 * b));
    pathQ = pathQ * (1 -q); % ��Ϣ��˥��
    
    bestCurrPath = zeros(1, pointNum -1);
    bestCurrPathLen = inf;
    for j = 1: antNum
        % �滮 ����·��
        antPath = zeros(1, pointNum -1);
        remainPoint = 2: pointNum;
        [newpoint, remainPoint] = choosePoint(1, remainPoint, pathWeight); % ����pathWeight������ѡ����һ�ڵ�
        antPath(1, 1) = newpoint; 
        for k = 2: pointNum -1
            [newpoint, remainPoint] = choosePoint(newpoint, remainPoint, pathWeight); % ����pathWeight������ѡ����һ�ڵ�
            antPath(1, k) = newpoint; 
        end
        % ���� ·����Ϣ��
        antPathLen = pathlength(antPath, dist);
        pathQ = addPathQ(pathQ, antPath, Q / antPathLen);
        % ���� ������Ⱥ���Ž�
        if bestCurrPathLen > antPathLen
            bestCurrPathLen = antPathLen;
            bestCurrPath = antPath;
        end
    end
    % ���� ��ʷ���Ž�
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
