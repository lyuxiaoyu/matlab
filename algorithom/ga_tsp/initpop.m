function chrom = initpop(NIND, PRECI)
    chrom = zeros(NIND, PRECI);
    for j = 1: NIND
        chrom(j, :) = randperm(PRECI);
    end
    chrom = chrom + 1;
end