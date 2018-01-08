clear   
clc

load  dayAheadResult_20180108163859.mat

iterMax = 100;

for iter = 1: iterMax
    % 实际出力，并计算与申报的偏差量
    dP = zeros(vppNum, T);
    for i = 1: vppNum
        s = ceil(rand * dayAheadResult(i).S);       
        dP(i, :) = dayAheadResult(i).dPst(s, :);
    end
    
    % 合作
    recordPrice = zeros(1, T);
    recordQ = zeros(vppNum, T);

    for t = 1: T
            [recordPrice(t), tmpQ] = bidding(dP(:, t)');
            recordQ(:, t) = tmpQ';
    end
    
    % 每个vpp收益增加量
    profitT = recordQ .* ((recordQ > 0) * 0.4 + (recordQ < 0) * (-1.2));
    profitVpp = sum(profitT, 2);
    profitAll(iter) = sum(profitVpp);
end

% 各vpp合作前收益
Object = zeros(vppNum, 1);
for i = 1: vppNum
    Object(i) = dayAheadResult(i).Object;
end
sum(Object)

mean(profitAll)