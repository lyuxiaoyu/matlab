clear   
clc

load  ./record/dayAheadResult_20180115170618.mat
% [dayAheadResult, caseOder,  T, vppNum] = dayaheadscheduling(2, 1, "save");

u = 0.0001;                  % 元/(kwh * kwh)  % 需求舒适度补偿系数 
c1 = ones(1,T) * 0.61;  %
cb = ones(1,T) * 0.71;  % 向外购电价格

clt = ones(1,T) * 0.59;     % 峰谷电价
clt(1: 7) = 0.34;   
clt(17: 21) = 0.87;

cp = ones(1,T) * 0.95;
cn = ones(1,T) * 0.45;

iterMax = 100;
profitVppBefore = zeros(vppNum, iterMax);
profitAddVpp = zeros(vppNum, iterMax);
transportVpp = zeros(vppNum, iterMax);

% for i = 1: vppNum
%     dayAheadResult(i).dPst =  dayAheadResult(i).dPst;
% end

parfor iter = 1: iterMax
    display(iter);
    
    % 实际出力，并计算与申报的偏差量
    dP = zeros(vppNum, T);
    ds = zeros(vppNum, 1);
    rs = zeros(vppNum, 1);
    ps = zeros(vppNum, 1);
    
    for i = 1: vppNum
        % 随机选择场景
        s = ceil(rand * dayAheadResult(i).S);    
        % 每个vpp误报量
        dP(i, :) = dayAheadResult(i).dPst(s, :) ;
        
        % 调整前，收益
        ds(i) = u * sum(dayAheadResult(i).dPLst(s, :) .^ 2, 2);
        rs(i) = (dayAheadResult(i).P1st(s, :) + dayAheadResult(i).P2st(s, :) + dayAheadResult(i).PEst(s, :)) * c1' ...
                + dayAheadResult(i).PSLst(s, :) * (clt - c1)' - dayAheadResult(i).PBst(s, :) * (cb - clt)';      % 购电售电
        ps(i) = abs(dayAheadResult(i).dPst(s, :)) * (cp+cn)' / 2 + dayAheadResult(i).dPst(s, :) * (cp-cn)' / 2;
        profitVppBefore(i, iter) = rs(i) - ps(i) - ds(i);
    end
    
    % 合作
    recordPrice = zeros(1, T);
    recordQ = zeros(vppNum, T);

    for t = 1: T
            [recordPrice(t), tmpQ] = bidding(-dP(:, t)', cn(t), cp(t));
            recordQ(:, t) = -tmpQ';
    end
    
%     % 调整后
%     dPAfter = recordQ + dP;
%     % 少报，实际出力大于申报量
%     nps = dPAfter .* -(dPAfter < 0) .* cn + recordQ .* (recordQ > 0) .* -recordPrice;
%     npsVpp = sum(nps, 2);
%     cnAfter = npsVpp ./ sum((dP .* -(dP < 0)), 2);   % 平均惩罚价格
%     
%     % 多报，实际出力小于申报量
%     pps = dPAfter .* (dPAfter > 0) .* cp + recordQ .* -(recordQ < 0) .* recordPrice;
%     ppsVpp = sum(pps, 2);
%     cpAfter = ppsVpp ./ sum((dP .* (dP > 0)), 2);   % 平均惩罚价格
    
    ctran = 0.15;
    % 每个vpp收益增加量
    profitAddNps = recordQ .* (recordQ > 0) .* (cn - ctran + recordPrice);
    profitAddPps = recordQ .* -(recordQ < 0) .* (cp - ctran - recordPrice);
    profitAddVpp(:,iter) = sum(profitAddNps + profitAddPps, 2);
    
    transportSeller = recordQ .* (recordQ > 0) .* ctran;
    transportBuyer = recordQ .* -(recordQ < 0) .* ctran;
    transportVpp(:,iter) = sum(transportSeller + transportBuyer, 2);
    
    % sum(cn * dP .* -(dP < 0), 2) - npsVpp - sum(profitAddNps, 2)
    % sum(cp * dP .* (dP > 0), 2) - ppsVpp - sum(profitAddPps, 2)
    % ps - npsVpp - ppsVpp - profitAddVpp
end

mean(sum(profitVppBefore))
mean(sum(profitAddVpp))
mean(sum(transportVpp))

mean(sum(profitAddVpp)) / mean(sum(profitVppBefore))