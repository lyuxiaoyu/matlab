clear   
clc

load  dayAheadResult.mat

Pnt = squeeze(result.P1st(:, 6, :) + result.Qst(:, 6, :));
P0nt = result.P0t;
dP  = Pnt - P0nt;
plot(dP);
dPsum = sum(dP, 1);



tmp1 = dP;
tmp1(dP < 0) = 0;
tmp1 = sum(tmp1, 1);
tmp2 = dP;
tmp2(dP > 0) = 0;
tmp2 = sum(tmp2, 1);
rate = tmp1 ./ -tmp2;

for i = 1: result.T
    if(rate(i) < 3) && (rate(i) > 0.3)
        record(i) = bidding((dP(:, i)));
    else
        record(i) = 0;
    end
end


figure(2);
plot(1:24, tmp1, 1:24, -tmp2);

plot(1: sum(record ~= 0), rate(record ~= 0), 1: sum(record ~= 0), record(record ~= 0));
