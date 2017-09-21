function fit = fitness(objv)
    m = max(objv) + 1;
    fit = m -objv;
    fit(fit < 0) = 0;
end