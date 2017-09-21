clear
clc

%% Ŀ�꺯��ͼ��
lb = 1;
ub = 2;
figure(1);
hold on;
ezplot('sin(10*pi*X)/X', [lb,ub]); % ��ȡ��Сֵ
xlabel('X');
ylabel('Y');

%% �Ŵ��㷨��ʼ��
NIND = 40;
MAXGEN = 20;
PRECI = 20;
GGAP = 0.95;
px = 0.7;
pm = 0.01;
trace = zeros(2, MAXGEN);
fieldD = [PRECI; lb; ub; 1; 0; 1; 1];
chrom = crtbp(NIND, PRECI);

%% �Ŵ��㷨
gen = 0;
x = bs2rv(chrom, fieldD);
objv = sin(10 * pi * x) ./ x;
while gen < MAXGEN
    gen = gen +1;
    fitnV = ranking(objv);                      % ��Ӧ��ֵ
    selCh = select('sus', chrom, fitnV, GGAP);  % ѡ��
    selCh = recombin('xovsp', selCh, px);       % ��������
    selCh = mut(selCh, pm);                     % ����
    x = bs2rv(selCh, fieldD);                   % ����
    objvSel = sin(10 * pi * x) ./ x;            % �����Ӵ�Ŀ�꺯��ֵ
    [chrom, objv] = reins(chrom, selCh, 1, 1, objv, objvSel);        % ����Ӵ��͸����õ�����Ⱥ
    x = bs2rv(chrom, fieldD);                   % ����
    [y, index] = min(objv);                     % ����ÿ�����Ž�
    trace(1, gen) = x(index);
    trace(2, gen) = y;
end

%% �����ʾ
plot(trace(1, :), trace(2, :), 'bo');           % ÿ������ֵ����ԭͼ���ϱ�ʾ
grid on;
plot(x, objv, 'b*');                            % �����Ⱥ
hold off;
figure(2);
plot(1:MAXGEN, trace(2, :));                    % ÿ������ֵ
xlabel('�Ŵ�����');
ylabel('ÿ�����Ž�');


