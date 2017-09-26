function drawpath(co, order, n)
    figure(n);
    plot(co(:, 1), co(:, 2), 'o', 'color', [0.5 0.5 0.5]);
    hold on;
    plot(co(1, 1), co(1, 2), '*', 'color', [0.5 0.5 0.5]);
    len = size(order, 2);
    % display(order);
    for j = 1: len - 1
        s = order(j);
        e = order(j+1);
        plot(co([s e], 1), co([s e], 2), 'r-');
        % arrow(co(s, :), co(e, :));
    end
    hold off
end
