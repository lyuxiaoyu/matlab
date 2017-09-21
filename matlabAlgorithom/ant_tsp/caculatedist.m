function dist = caculatedist(co)
    len = size(co, 1);
    dist = zeros(len);
    for j = 1: len - 1
        for k = j + 1: len
            dist(k, j) = sqrt(sum((co(k, :) - co(j, :)).^2));
            dist(j, k) = dist(k, j);
        end
    end
end