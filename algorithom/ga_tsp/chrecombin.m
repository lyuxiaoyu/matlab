function selCh = chrecombin(chrom, px)
    [n, PRECI] = size(chrom);
    reIndex = randperm(n);
    selCh = zeros(n, PRECI);
    for j = 1: 2: n
        a = chrom(reIndex(j), :);
        b = chrom(reIndex(j+1), :);
        if px > rand
            a0 = a;
            b0 = b;
            node = ceil(rand * PRECI-1);
            for k = 1: node
                atmp = a(k); 
                btmp = b(k);
                a(k) = b0(k);
                b(k) = a0(k);

                for l = 1: PRECI
                    if a(l) == a(k) && l ~= k;
                        a(l) = atmp;
                    end
                end

                for l = 1: PRECI
                    if b(l) == b(k) && l ~= k;
                        b(l) = btmp;
                    end
                end
            end
        end
        selCh(j, :) = a;
        selCh(j+1, :) = b;
    end
end