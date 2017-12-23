function Q = REImprove(reward, decision, Q)
      r = 0.03;
     e = 0.97;
%     tmpQ = (1 - r) * Q(decision) + (1 - e) * reward;
%     Q = (1 - r + e / size(Q, 2)) * Q;

    tmpQ = (1 - r) * Q(decision) + (1 - e) * reward;
    Q = (1 - r + 0.02) * Q;
    Q(decision) = tmpQ;
end