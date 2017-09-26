clc
clear

d = 0.15;    % ��������
d_sim = 0.05;   % ��ԭ����
%% ԭ��������������ʾԭͼ��
x = meshgrid(-2: d: 2);
y = meshgrid(-2: d: 2)';
xy = [x(:), y(:)];
z = testfunc(xy);   % �ȷֲ���
n = size(x, 1);
m = size(y, 2);
z_mesh = zeros(n, m);
for j = 1: n
    z_mesh(j, :) = z(j*m-m+1: j*m);
end
figure(1);
mesh(x, y, z_mesh);

% xy = rand([400, 2]) * 4 - 2; % �������
% z = testfunc(xy);

%% ����bf���߹���������
node = [20 20];                 % ÿ���������Ԫ����
net = newff(xy', z', node);     % �������磬ÿ��Ϊһ������

net.trainParam.epochs = 500;    % ��������
net.trainParam.goal = 1e-6;     % Ŀ�꾫��
net.trainParam.lr = 0.01;       % ����

net = train(net, xy', z');      % ѵ������

%% �Ը��߾��Ȼ�ԭͼ��
x = meshgrid(-2: d_sim: 2);
y = meshgrid(-2: d_sim: 2)';
xy = [x(:), y(:)];
z_sim = sim(net, xy');          % ����

%% ��ʾ��ԭͼ��
n = size(x, 1);
m = size(y, 2);
z_mesh = zeros(n, m);
for j = 1: n
    z_mesh(j, :) = z_sim(j*m-m+1: j*m);
end
figure(2);
mesh(x, y, z_mesh);