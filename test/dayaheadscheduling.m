function result = dayaheadscheduling()
    fileName = "data.xlsx";

    T = 24;
    S = 10;
    VppN = 8;
    
    result = [];
    result.Object = zeros(VppN, 1);
    result.P1st = zeros(VppN, S, T);
    result.Est = zeros(VppN, S, T+1);
    result.Qst = zeros(VppN, S, T);
    result.P0t = zeros(VppN, T);
    result.T = T;
    result.S = S;
    result.VppN = VppN;

    % 电价
    % cto = ones(1,T) * 0.59; % 峰谷电价
    % cto(1: 7) = 0.26;   
    % cto(17: 21) = 0.92;
    cto = ones(1,T) * 0.61;
    alpha = 1;
    cp = 1.2 / alpha;
    cn = 0.4 * alpha;

    % 初始化变量
    P1st = sdpvar(S, T);
    Est = sdpvar(S, T+1);
    Qst = sdpvar(S, T);
    P0t = sdpvar(1, T);


    for oder = 1: VppN
    % 读取数据
        wpp = xlsread(fileName, oder + 1, "B5: B14");
        wp = xlsread(fileName, oder + 1, "C5: Z14");
        Eini = xlsread(fileName, oder + 1, "C3");
        EMax = xlsread(fileName, oder + 1, "D3");
        QMax = xlsread(fileName, oder + 1, "E3");
        QMin = xlsread(fileName, oder + 1, "F3");

        % 风电
        P1stMax = wp * 1000; % mk转化为 kw
        pro = wpp;
        P1sMax = sum(P1stMax, 2);
        P1sMin = P1sMax * (1 - 0.05);

        % 电池
        EMin = 0;
        % Eini = 2000;        % kw * h
        % EMax = 4000;       % kw * h
        % QMax = 600;    %kw
        % QMin = -600;

        % 目标函数
        dPt = (repmat(P0t,[S 1])- P1st - Qst);
        f = pro' * ((P1st + Qst)* cto' + sum(-(cp+cn)/2 * abs(dPt) - (cp-cn)/2 * dPt, 2));

        % 约束
        F = [];
        F = F + (0 <= P1st <= P1stMax);       %(4)
        F = F + (sum(P1st, 2) >= P1sMin);    % (5)
        F = F + (EMin <= Est <= EMax);    % (9)
        F = F + (Est(:, 1) == Eini) + (Est(:, 25) == Eini);   % (10)
        F = F + (QMin <= Qst <= QMax);   % (11)

        for t = 1: T
            F = F + (Est(:, t+1) == Est(:, t) - Qst(:, t)); % (8) 
        end

        ops = sdpsettings('solver', 'lpsolve');
        optimize(F, -f, ops);  % 解决最小化问题

        % 结果
        result.Object(oder) = double(f);
        result.P1st(oder,:,:) = double(P1st);
        result.Est(oder,:,:) = double(Est);
        result.Qst(oder,:,:) = double(Qst);
        result.P0t(oder,:) = double(P0t);
    end 
end
