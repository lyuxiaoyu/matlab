clear   
clc

load  dayAheadResult.mat
% result = dayaheadscheduling();

Pnt = zeros(result.VppN, result.T);
for i = 1: result.VppN
    s = ceil(rand * result.S); 
    Pnt(i, :) = squeeze(result.P1st(i, s, :) + result.Qst(i, s, :));
end


P0nt = result.P0t;
dP  = Pnt - P0nt;
dPsum = sum(dP, 1);
before = sum(dP(dP > 0)) * 0.4 + sum(-dP(dP < 0) * 1.2);
after = sum(dPsum(dPsum > 0)) * 0.4 + sum(-dPsum(dPsum < 0) * 1.2);

profitBefore = sum(sum(Pnt * 0.61, 2)) - before;
profitAfter = sum(sum(Pnt * 0.61, 2)) - after;


tmp1 = dP;
tmp1(dP < 0) = 0;
tmp1 = sum(tmp1, 1);
tmp2 = dP;
tmp2(dP > 0) = 0;
tmp2 = sum(tmp2, 1);
plot(1:24, tmp1, 1:24, -tmp2);


rate = tmp1 ./ -tmp2;
tmp = rate(rate < 1.5);
tmp = tmp(tmp > 1 / 1.5);


for i = 1: result.T
    if(rate(i) < 3) && (rate(i) > 0.3)
        record(i) = bidding(dP(:, i)');
    else
        record(i) = 0;
    end
end


figure(3);

plot(1: sum(record ~= 0), rate(record ~= 0), 1: sum(record ~= 0), 2 - record(record ~= 0));
