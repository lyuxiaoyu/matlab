function z = psot_func(in)
    x = in(:, 1);
    y = in(:, 2);
    len = size(in, 1);
    z = zeros(len, 1);
    for i = 1: len
        z(i, :) = 0.5*(x(i)-3)^2+0.2*(y(i)-5)^2-0.1;
    end
end
