x = [0: 0.01: 7];
y1 = sin(x);
y2 = sin(x + 0.25 * pi);
z1 = sin(x);
z2 = sin(2 * x);
subplot(1,1,1);%(ºá×ø±ê¡¢×Ý×ø±ê¡¢Í¼±êºÅ
plot(y1,y2,z1,z2), xlabel('x'),ylabel('y'), title('Sin(x)'), grid on, axis equal, 
legend('1','2');
