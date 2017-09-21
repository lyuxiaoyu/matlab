function len = pathlength(chrom, dist)
    [antNum, pointNum] = size(chrom);
    len = zeros(antNum, 1);
    for j = 1: antNum
        tmp = dist(1, chrom(j,1)) + dist(1, chrom(j, pointNum));
        for k = 1: pointNum-1
            tmp = tmp + dist(chrom(j, k), chrom(j, k + 1));
        end
        len(j) = tmp;
    end
end