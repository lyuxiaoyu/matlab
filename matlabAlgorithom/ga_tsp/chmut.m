function chrom = chmut(selCh, pm)
    [n, PRECI] = size(selCh);
    chrom = selCh;
    for j = 1: n
        if rand < pm
            bound = randperm(PRECI, 2);
            s = min(bound);
            e = max(bound);
            chrom(j, s: e) = selCh(j, e: -1: s);
        end
    end
end