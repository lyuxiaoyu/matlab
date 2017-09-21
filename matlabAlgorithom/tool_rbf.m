clc
clear

% bf���ڻع�
% rbf���ڻع飬������bf�������ݽϴ�������
% net = newgrnn(xy', z');   % grnn���ڷ���
% net = newpnn(xy', z');    % pnn���ڷ���
% somf ���ھ���

d = 0.1;    % ��������
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

%% ����rbf����������
net = newrbe(xy', z');    % rbf���ڻع�     % ÿ��Ϊһ������

%% �Ը��߾��Ȼ�ԭͼ��
x = meshgrid(-2: d_sim: 2);
y = meshgrid(-2: d_sim: 2)';
xy = [x(:), y(:)];
z_sim = sim(net, xy');      % ����

%% ��ʾ��ԭͼ��
n = size(x, 1);
m = size(y, 2);
z_mesh = zeros(n, m);
for j = 1: n
    z_mesh(j, :) = z_sim(j*m-m+1: j*m);
end
figure(2);
mesh(x, y, z_mesh);

