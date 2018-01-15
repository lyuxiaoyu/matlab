clc
clear

excelFileName = "../data.xlsx";

vppSheetBias = xlsread(excelFileName, 1, "A3");
vppNum = 1;   
vppSheetOder = vppNum + vppSheetBias;

[~, chooseArea] = xlsread(excelFileName, vppSheetOder, "B3");
wp = xlsread(excelFileName, vppSheetOder, chooseArea{1});

plot(wp' / 1000)
xlabel('t / h'),ylabel('wind power / MW'), title(' '), 

grid on, axis ([0 25 0 40]), 