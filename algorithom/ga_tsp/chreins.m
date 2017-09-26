function [chrom, objV] = chreins(chrom, selCh, objV, objVSel)
    n = size(chrom, 1);
    chrom = [chrom; selCh];
    objV = [objV; objVSel];
    [~, index] = sort(objV);
    
    %m = ceil(n / 3);
    %index = [index(1:m); index(randperm(size(chrom, 1) - m, n - m) + m)];
    index = index(1:n);
    chrom = chrom(index, :);
    objV = objV(index);
end