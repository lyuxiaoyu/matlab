function decision = REDecision(Q)
    m = size(Q, 2);
    k = 0.5;
    c = k * mean(Q);
    expQ = exp(Q / c);
    p = expQ / sum(expQ);
    
    decision = m;
    threshold = rand;
    sump = 0;
    for i = 1: m
        sump = sump + p(i);
        if sump > threshold
            decision = i;
            break;
        end
    end
end