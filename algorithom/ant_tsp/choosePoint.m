function [point, remainPoint] = choosePoint(currPoint, remainPoint, pathWeight) 
    remainNum = size(remainPoint, 2);
    randSum = rand * sum(pathWeight(currPoint, remainPoint));
    tmp = 0;
    for i = 1: remainNum
        tmp = tmp + pathWeight(currPoint, remainPoint(i));
        if randSum < tmp
            point = remainPoint(i);
            remainPoint(i) =[];
            break;
        end
    end
end
