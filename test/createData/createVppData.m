clc
clear

excelFileName = "data.xlsx";
sheetOder = 2;
vppInfo = xlsread(excelFileName,  sheetOder, "B3:C11");
vppNum = size(vppInfo, 1);

% A3 B3
% B12:B21  C12:Z21

% A5 B5
% B24:B28  C24:Z28

vppSheetBias = xlsread(excelFileName, 1, "A3");

for vppOder = 1: vppNum
    display(vppOder);
    vppSheetOder = vppOder + vppSheetBias;
    
    flagWind = vppInfo(vppOder, 1) > 0;
    flagSolar = vppInfo(vppOder, 2) > 0;
    
    if (flagWind && flagSolar)
        K = 7;
        areaWindP = "B12:B18";
        areaWind = "C12:Z18";
        areaSolarP = "B24:B30";
        areaSolar = "C24:Z30";
    else
        K = 10;
        areaWindP = "B12:B21";
        areaWind = "C12:Z21";
        areaSolarP = "B24:B28";
        areaSolar = "C24:Z28";
    end
    
    xlswrite(excelFileName, ' ', vppSheetOder, "B12:Z22");
    xlswrite(excelFileName, ' ', vppSheetOder, "B24:Z29");   
        
    if (flagWind)
        areaWindData = sprintf("B%d:Y%d", vppOder+14, vppOder+14);
        dataWind = xlsread(excelFileName,  sheetOder, areaWindData);
        [pro1, wp] = createScene(dataWind, K);
        
        xlswrite(excelFileName, {char(areaWindP)}, vppSheetOder, "A3");
        xlswrite(excelFileName, {char(areaWind)}, vppSheetOder, "B3");
        xlswrite(excelFileName, pro1, vppSheetOder, areaWindP);
        xlswrite(excelFileName, wp, vppSheetOder, areaWind);
    else
        xlswrite(excelFileName, {char("null")}, vppSheetOder, "A3");
        xlswrite(excelFileName, {char("null")}, vppSheetOder, "B3");
    end
        
    
    if (flagSolar)
        areaSolarData = sprintf("B%d:Y%d", vppOder+28, vppOder+28);
        dataSolar = xlsread(excelFileName,  sheetOder, areaSolarData);
        [pro2, sp] = createScene(dataSolar, K);
        
        xlswrite(excelFileName, {char(areaSolarP)}, vppSheetOder, "A5");
        xlswrite(excelFileName, {char(areaSolar)}, vppSheetOder, "B5");
        xlswrite(excelFileName, pro2, vppSheetOder, areaSolarP);
        xlswrite(excelFileName, sp, vppSheetOder, areaSolar);
    else
        xlswrite(excelFileName, {char("null")}, vppSheetOder, "A5");
        xlswrite(excelFileName, {char("null")}, vppSheetOder, "B5");
    end
    
end



