t = 1:0.1:50;
x = 0.1 * t .* sin(t + 0.5 * pi);
y = 0.1 * t .* sin(t);
figure(1);
plot3(x, y, t);
axis square;
grid on;