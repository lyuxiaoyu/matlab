clc
clear

load('dayAheadResult_20180115170618.mat')

excelFileName = "../data.xlsx";

vppSheetBias = xlsread(excelFileName, 1, "A3");
vppNum = 1;   
vppSheetOder = vppNum + vppSheetBias;

[~, chooseArea] = xlsread(excelFileName, vppSheetOder, "B3");
wp = xlsread(excelFileName, vppSheetOder, chooseArea{1});

[~, chooseArea] = xlsread(excelFileName, vppSheetOder, "B5");
sp = xlsread(excelFileName, vppSheetOder, chooseArea{1});


r = dayAheadResult(1);
    display(r.Object);
    s = 1;
plot(1:24, r.P0t ...
, 1:24, wp(s, :) + sp(s, :) - r.PL + r.PEst(s, :) - r.dPLst(s, :) ...
, 1:24, wp(s, :) + sp(s, :) ...
, 1:24,  r.PL ...
, 1:24, r.PEst(s, :) ...
, 1:24, -r.dPLst(s, :) ...
);

xlabel('t / h'),ylabel('kW'), title(' '), 
legend('申报出力/负荷', '实际出力/负荷', '风、光出力和', "负荷", "储能", "需求响应");
grid on, 
