clc
clear

d = 0.15;    % 采样精度
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

%% 利用bf工具构建神经网络
node = [20 20];                 % 每个隐层的神经元数量
net = newff(xy', z', node);     % 创建网络，每列为一组数据

net.trainParam.epochs = 500;    % 迭代次数
net.trainParam.goal = 1e-6;     % 目标精度
net.trainParam.lr = 0.01;       % 步长

net = train(net, xy', z');      % 训练网络

%% 以更高精度还原图像
x = meshgrid(-2: d_sim: 2);
y = meshgrid(-2: d_sim: 2)';
xy = [x(:), y(:)];
z_sim = sim(net, xy');          % 仿真

%% 显示还原图像
n = size(x, 1);
m = size(y, 2);
z_mesh = zeros(n, m);
for j = 1: n
    z_mesh(j, :) = z_sim(j*m-m+1: j*m);
end
figure(2);
mesh(x, y, z_mesh);