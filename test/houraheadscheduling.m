clear   
clc

load  dayAheadResult_20180108163859.mat

iterMax = 100;

for iter = 1: iterMax
    % ʵ�ʳ��������������걨��ƫ����
    dP = zeros(vppNum, T);
    for i = 1: vppNum
        s = ceil(rand * dayAheadResult(i).S);       
        dP(i, :) = dayAheadResult(i).dPst(s, :);
    end
    
    % ����
    recordPrice = zeros(1, T);
    recordQ = zeros(vppNum, T);

    for t = 1: T
            [recordPrice(t), tmpQ] = bidding(dP(:, t)');
            recordQ(:, t) = tmpQ';
    end
    
    % ÿ��vpp����������
    profitT = recordQ .* ((recordQ > 0) * 0.4 + (recordQ < 0) * (-1.2));
    profitVpp = sum(profitT, 2);
    profitAll(iter) = sum(profitVpp);
end

% ��vpp����ǰ����
Object = zeros(vppNum, 1);
for i = 1: vppNum
    Object(i) = dayAheadResult(i).Object;
end
sum(Object)

mean(profitAll)