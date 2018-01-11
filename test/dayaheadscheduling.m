function [dayAheadResult, caseOder,  T, vppNum] = dayaheadscheduling(caseOder, alpha, flagSave)
tic

if ~exist("flagSave", "var")
    flagSave = " "; % �Ƿ񱣴���
end

if ~exist("caseOder", "var")
    caseOder = 1;   % ����ѡ��
end

if ~exist("alpha", "var")
    alpha = 1.0;
end

% excel�ļ���
excelFileName = "data.xlsx";


% ����ѡ��
caseArea = {"B8", "C8", "D8", "E8", "F8"};
[~, chooseArea] = xlsread(excelFileName, 1, caseArea{caseOder});   
caseSet = int16(xlsread(excelFileName, 1, chooseArea{1}));
vppOderSet = caseSet(:, 1);                 
flagStorgeSet = caseSet(:, 2);             % �Ƿ����ô���
flagDemandResponseSet =  caseSet(:, 3);    % �Ƿ�����������Ӧ

% ��ʼ��
T = 24;
vppSheetBias = xlsread(excelFileName, 1, "A3");
vppNum = size(vppOderSet, 1);   

% �������
dayAheadResult(vppNum, 1) = ...
    struct('vppOder', [], 'S', [], 'Object',[], 'P1st',[], 'P2st',[], 'PEst',[], 'PGst', [], ...
    'dPLst', [], 'PBst', [],'PSLst',[], 'dPst', [], 'PL',[],  'P0t', []);
    
parfor oder = 1: vppNum
    vppOder = vppOderSet(oder);
    flagStorge = flagStorgeSet(oder);             % �Ƿ����ô���
    flagDemandResponse =  flagDemandResponseSet(oder);    % �Ƿ�����������Ӧ
    vppSheetOder = vppOder + vppSheetBias;
    
    fprintf("\n########################## vpp:%d ##############################\n", vppOder);
    
    F = [];
    % toc
%% ���
    u = 0.0001;                  % Ԫ/(kwh * kwh)  % �������ʶȲ���ϵ�� 
    % cto = ones(1,T) * 0.59; % ��ȵ��
    % cto(1: 7) = 0.31;   
    % cto(17: 21) = 0.92;
    % alpha = 1;
    cp = 1.2 / alpha;
    cn = 0.4 * alpha;
    c1 = ones(1,T) * 0.61;  % ����Դ�۸�
    clt = ones(1,T) * 0.61; % �����۵�۸�
    cb = ones(1,T) * 0.69;         % ���⹺��۸�

    % toc
%% ��ⳡ��

    flagWp = 0;
    flagSp = 0;

    % ��
    [~, chooseArea] = xlsread(excelFileName, vppSheetOder, "A3");
    if ("null" ~= chooseArea{1})
        flagWp = 1;
        pro1 = xlsread(excelFileName, vppSheetOder, chooseArea{1});
        [~, chooseArea] = xlsread(excelFileName, vppSheetOder, "B3");
        wp = xlsread(excelFileName, vppSheetOder, chooseArea{1}); %  kw
    end

    % ��
    [~, chooseArea] = xlsread(excelFileName, vppSheetOder, "A5");
    if ("null" ~= chooseArea{1})
        flagSp = 1;
        pro2 = xlsread(excelFileName, vppSheetOder, chooseArea{1});
        [~, chooseArea] = xlsread(excelFileName, vppSheetOder, "B5");
        sp = xlsread(excelFileName, vppSheetOder, chooseArea{1}); %  kw
    end

    if (1 == flagWp && 1 == flagSp)
        pro = (pro1 * pro2');
        pro = pro(:);                       % ����������
        S1 = size(pro1, 1);           
        S2 = size(pro2, 1);           
        S = S1 * S2;                        % ��������

        P1stMax = wp; 
        P1stMax = repmat(P1stMax, [S2 1]);  % ���������������
        P2stMax = zeros(S,T);               % ���������������
        for i = 1:S2
            P2stMax((i-1)*S1+1: i*S1, :) = repmat(sp(i, :), [S1, 1]);
        end
    elseif (1 == flagWp)
        pro = pro1;                 % ����������
        S = size(pro, 1);           % ��������
        P1stMax = wp;               % ���������������
    else
        pro = pro2;                 % ����������
        S = size(pro, 1);           % ��������
        P2stMax = sp;               % ���������������
    end

    if (1 == flagWp)
        P1st = sdpvar(S, T);        % ��������ƻ�����
        % Լ��
        F = F + (0 <= P1st);
        F = F + (P1st <= P1stMax);      
        F = F + (sum(P1st, 2) >= sum(P1stMax, 2) * (1 - 0.05));   
    else
        P1st = zeros(S, T);
    end

    if (1 == flagSp)
        P2st = sdpvar(S, T);        % ��������ƻ�����
        % Լ��
        F = F + (0 <= P2st);
        F = F + (P2st <= P2stMax);      
        F = F + (sum(P2st, 2) >= sum(P2stMax, 2) * (1 - 0.05)); 
    else
        P2st = zeros(S, T);
    end

    % toc
%% ����
    % ��ʼ��
    if (1 == flagStorge)
        PEst = sdpvar(S, T);
        Est = sdpvar(S, T+1);

        Eini = xlsread(excelFileName, vppSheetOder, "C3");
        EMax = xlsread(excelFileName, vppSheetOder, "D3");
        EMin = 0;
        PEMax = xlsread(excelFileName, vppSheetOder, "E3");
        PEMin = xlsread(excelFileName, vppSheetOder, "F3");

        % Լ��
        F = F + (EMin <= Est);
        F = F + (Est <= EMax);    % ����Լ��
        F = F + (Est(:, 1) == Eini) + (Est(:, 25) == Eini);   % 
        F = F + (PEMin <= PEst);
        F = F + (PEst <= PEMax);  % 
        for t = 1: T
            F = F + (Est(:, t+1) == Est(:, t) - PEst(:, t)); % 
        end
    else
        PEst = zeros(S, T);
        Est = zeros(S, T+1);
    end

    % toc
%% ����
    % ��ʼ��
    [~, chooseArea] = xlsread(excelFileName, vppSheetOder, "C5");
    if ("null" ~= chooseArea{1})
        flagPL = 1;     % �Ƿ��и���
        PL = xlsread(excelFileName, vppSheetOder, chooseArea{1});  % 1 * T  % kw
    else
        flagPL = 0;
        PL = zeros(1, T);
    end

    % toc
%% ������Ӧds
    if (1 == flagDemandResponse && 1 == flagPL)    % �Ƿ�����������Ӧ
        % ��ʼ��
        dPLst = sdpvar(S, T);       % ������Ӧ��

        % Լ��
        F = F + (dPLst <= repmat(PL,[S 1]) * 0.1);  % ����������ӦԼ��
        F = F + (dPLst >= -repmat(PL,[S 1]) * 0.1);
        F = F + (sum(dPLst, 2) == zeros(S, 1));
        for t = 1: T - 1
            F = F + (abs(dPLst(:, t)) / PL(t) +  abs(dPLst(:, t + 1)) / PL(t + 1) <= 0.08);
        end
    else
        dPLst = zeros(S, T);
    end 

    % ������Ӧ����
    ds = u * sum(dPLst .^ 2, 2); 

    % toc
%% vpp������������
    PGst = P1st + P2st + PEst; %vpp������������
    
    % toc
%% �۵繺��rs

    if (1 == flagPL)
        % ��ʼ��
        PSLst = sdpvar(S, T);                           % �ڲ��۵���

        % Լ��
        PBst = repmat(PL,[S 1]) + dPLst - PSLst;          % ����ƽ��
        F = F + (0 <= PSLst);
        F = F + (PSLst <= PGst);            % ����Դ���۵���Լ��
        F = F + (PSLst <= repmat(PL,[S 1]) + dPLst);
    else
        PSLst = zeros(S, T);
        PBst = zeros(S, T);
    end

    % �۵繺���
    % PGst = P1st + P2st + PEst;    %vpp������������
    rs = PGst * c1' + PSLst * (clt - c1)' - PBst * (cb - clt)';      % �����۵�

    % toc
%% �����ͷ�ds
    % ��ʼ��
    P0t = sdpvar(1, T);     % �걨��

    % �����ͷ���
    dPst = repmat(P0t,[S 1]) - (PGst - dPLst - repmat(PL,[S 1]));     % ����
    ps = sum((cp+cn)/2 * abs(dPst) + (cp-cn)/2 * dPst, 2);                    % �����ͷ�

    % toc
%% Ŀ�꺯��
    f =  pro' * (rs - ps - ds);                                            % ����Ŀ�꣬�ೡ������

    % toc
%% ���������
    ops = sdpsettings('solver', 'mosek');
    optimize(F, -f, ops);  % �����С������

    % toc
%% ���
    dayAheadResult(oder).vppOder = vppOder;
    dayAheadResult(oder).S = S;
    dayAheadResult(oder).Object = double(f);
    dayAheadResult(oder).P1st = double(P1st);
    dayAheadResult(oder).P2st = double(P2st);
    dayAheadResult(oder).PEst = double(PEst);
    dayAheadResult(oder).PGst = double(PGst);
    dayAheadResult(oder).dPLst = double(dPLst);
    dayAheadResult(oder).PBst = double(PBst);
    dayAheadResult(oder).PSLst = double(PSLst);
    dayAheadResult(oder).dPst = double(dPst);
    dayAheadResult(oder).PL = PL;
    dayAheadResult(oder).P0t = double(P0t);   
    

end
toc


if vppNum == 1
    r = dayAheadResult(1);
    display(r.Object);
    s = 3;
    plot(1:24, r.P1st(s, :) + r.P2st(s, :) ... 
    , 1:24, r.P0t ...
    , 1:24, r.PGst(s, :) - r.PSLst(s, :) - r.PBst(s, :) ...
    , 1:24, r.PL ...
    , 1:24, r.dPLst(s, :) + r.PL...     
    );
end


if "save" == flagSave
    resultSaveFileName = sprintf("./record/dayAheadResult_%s", datestr(now,'yyyymmddHHMMSS'));
    save(resultSaveFileName, ... 
        "dayAheadResult", "vppNum", "T", "caseOder");
    fprintf("result is saved in %s\n", resultSaveFileName);
end

