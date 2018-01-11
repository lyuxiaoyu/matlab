clear   
clc

% load  ./record/dayAheadResult_20180111153106.mat
[dayAheadResult, caseOder,  T, vppNum] = dayaheadscheduling(5, 1, "save");

u = 0.0001;                  % Ԫ/(kwh * kwh)  % �������ʶȲ���ϵ�� 
cp = 1.2;
cn = 0.4;
c1 = ones(1,T) * 0.61;      % �����۵�۸�
clt = ones(1,T) * 0.61;     % �����۵�۸�
cb = ones(1,T) * 0.69;      % ���⹺��۸�

iterMax = 100;
profitVppBefore = zeros(vppNum, iterMax);
profitAddVpp = zeros(vppNum, iterMax);

parfor iter = 1: iterMax
    display(iter);
    
    % ʵ�ʳ��������������걨��ƫ����
    dP = zeros(vppNum, T);
    ds = zeros(vppNum, 1);
    rs = zeros(vppNum, 1);
    ps = zeros(vppNum, 1);
    
    for i = 1: vppNum
        % ���ѡ�񳡾�
        s = ceil(rand * dayAheadResult(i).S);    
        % ÿ��vpp����
        dP(i, :) = dayAheadResult(i).dPst(s, :);
        
        % ����ǰ������
        ds(i) = u * sum(dayAheadResult(i).dPLst(s, :) .^ 2, 2);
        rs(i) = (dayAheadResult(i).P1st(s, :) + dayAheadResult(i).P2st(s, :) + dayAheadResult(i).PEst(s, :)) * c1' ...
                + dayAheadResult(i).PSLst(s, :) * (clt - c1)' - dayAheadResult(i).PBst(s, :) * (cb - clt)';      % �����۵�
        ps(i) = sum((cp+cn)/2 * abs(dayAheadResult(i).dPst(s, :)) + (cp-cn)/2 * dayAheadResult(i).dPst(s, :), 2);
        profitVppBefore(i, iter) = rs(i) - ps(i) - ds(i);
    end
    
    % ����
    recordPrice = zeros(1, T);
    recordQ = zeros(vppNum, T);

    for t = 1: T
            [recordPrice(t), tmpQ] = bidding(-dP(:, t)');
            recordQ(:, t) = -tmpQ';
    end
    
    % ������
    dPAfter = recordQ + dP;
    % �ٱ���ʵ�ʳ��������걨��
    nps = cn * dPAfter .* -(dPAfter < 0) + recordQ .* (recordQ > 0) .* -recordPrice;
    npsVpp = sum(nps, 2);
    cnAfter = npsVpp ./ sum((dP .* -(dP < 0)), 2);   % ƽ���ͷ��۸�
    % �౨��ʵ�ʳ���С���걨��
    pps = cp * dPAfter .* (dPAfter > 0) + recordQ .* -(recordQ < 0) .* recordPrice;
    ppsVpp = sum(pps, 2);
    cpAfter = ppsVpp ./ sum((dP .* (dP > 0)), 2);   % ƽ���ͷ��۸�
    
    % ÿ��vpp����������
    profitAddNps = recordQ .* (recordQ > 0) .* (cn + recordPrice);
    profitAddPps = recordQ .* -(recordQ < 0) .* (cp - recordPrice);
    profitAddVpp(:,iter) = sum(profitAddNps + profitAddPps, 2);
    
    % sum(cn * dP .* -(dP < 0), 2) - npsVpp - sum(profitAddNps, 2)
    % sum(cp * dP .* (dP > 0), 2) - ppsVpp - sum(profitAddPps, 2)
    % ps - npsVpp - ppsVpp - profitAddVpp
end

mean(sum(profitVppBefore))
mean(sum(profitAddVpp))



