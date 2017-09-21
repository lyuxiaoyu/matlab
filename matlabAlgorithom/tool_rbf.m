clc
clear

% bf用于回归
% rbf用于回归，稍优于bf，但数据较大可能溢出
% net = newgrnn(xy', z');   % grnn用于分类
% net = newpnn(xy', z');    % pnn用于分类
% somf 用于聚类

d = 0.1;    % 采样精度
d_sim = 0.05;   % 还原精度
%% 原函数采样，并显示原图像
x = meshgrid(-2: d: 2);
y = meshgrid(-2: d: 2)';
xy = [x(:), y(:)];
z = testfunc(xy);   % 等分采样
n = size(x, 1);
m = size(y, 2);
z_mesh = zeros(n, m);
for j = 1: n
    z_mesh(j, :) = z(j*m-m+1: j*m);
end
figure(1);
mesh(x, y, z_mesh);

% xy = rand([400, 2]) * 4 - 2; % 随机采样
% z = testfunc(xy);

%% 利用rbf构建神经网络
net = newrbe(xy', z');    % rbf用于回归     % 每列为一组数据

%% 以更高精度还原图像
x = meshgrid(-2: d_sim: 2);
y = meshgrid(-2: d_sim: 2)';
xy = [x(:), y(:)];
z_sim = sim(net, xy');      % 仿真

%% 显示还原图像
n = size(x, 1);
m = size(y, 2);
z_mesh = zeros(n, m);
for j = 1: n
    z_mesh(j, :) = z_sim(j*m-m+1: j*m);
end
figure(2);
mesh(x, y, z_mesh);

