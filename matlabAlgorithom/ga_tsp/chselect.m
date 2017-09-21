function selCh = chselect(chrom, fit, GGAP)
    [n, PRECI] = size(chrom);
    sn = ceil(GGAP * n);
    sn = sn - mod(sn, 2);
    selCh = zeros(sn, PRECI);
    pro = fit / sum(fit);
    spro = pro(1);
    k = 1;
    for j = 1: sn
        cpro = (j -0.5) / sn;
        while cpro > spro
            k = k + 1;
            spro = spro + pro(k);    
        end
        %display([j,k]);
        selCh(j, :) = chrom(k, :);
    end
end