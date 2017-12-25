clear   
clc

load  dayAheadResult.mat

iterMax = 10;

for iter = 1: iterMax
    Pnt = zeros(result.VppN, result.T);
    for i = 1: result.VppN
        s = ceil(rand * result.S); 
        Pnt(i, :) = squeeze(result.P1st(i, s, :) + result.Qst(i, s, :));
    end

    P0nt = result.P0t;
    dP  = Pnt - P0nt;
    
    recordPrice = zeros(1, result.T);
    recordQ = zeros(result.VppN, result.T);

    for t = 1: result.T
            [recordPrice(t), tmpQ] = bidding(dP(:, t)');
            recordQ(:, t) = tmpQ';
    end

    profitBefore = Pnt * 0.59 - (dP > 0) .* dP * 0.4 + (dP < 0) .* dP * 0.7;

    PntA = Pnt + recordQ;
    dPA = dP + recordQ;
    profitAfter = PntA * 0.59 - (dPA > 0) .* dPA * 0.4 + (dPA < 0) .* dPA * 0.7 - recordQ .* recordPrice;

    vppProfitBefore = sum(profitBefore, 2);
    vppProfitAfter = sum(profitAfter, 2);

    sumProfitBefore(iter) = sum(vppProfitBefore);
    sumProfitAfter(iter) = sum(vppProfitAfter);
    disp(iter);
end