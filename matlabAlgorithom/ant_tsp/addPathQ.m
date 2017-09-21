function pathQ = addPathQ(pathQ, antPath, d)
    n = size(antPath, 2);
    pathQ(1, antPath(1)) = pathQ(1, antPath(1)) + d;
    pathQ(antPath(1), 1) = pathQ(1, antPath(1));
    pathQ(antPath(n), 1) = pathQ(antPath(n), 1) + d;
    pathQ(1, antPath(n)) = pathQ(antPath(n), 1);
    for i = 1: n -1
        p1 = antPath(i);
        p2 = antPath(i+1);
        pathQ(p1, p2) = pathQ(p1, p2) + d;
        pathQ(p2, p1) = pathQ(p1, p2);
    end
end