function objV = pathlength(chrom, dist)
    [n, PRECI] = size(chrom);
    objV = zeros(n, 1);
    for j = 1: n
        tmp = dist(1, chrom(j,1)) + dist(1, chrom(j, PRECI));
        for k = 1: PRECI-1
            tmp = tmp + dist(chrom(j, k), chrom(j, k + 1));
        end
        objV(j) = tmp;
    end
end