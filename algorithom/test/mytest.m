numHalf = 5;
num = numHalf * 2 + 1;
T = 25; 
lineNum = numHalf * (T - 1) + 1;
lineNumHalf = (lineNum + 1) / 2;
arr = zeros(T, lineNum);
lim = [0:  numHalf: (lineNum-1)/2, (lineNum-1)/2 - numHalf:  -numHalf: 0];

arr(1,lineNumHalf) = 1;
for t = 1: T-1
    for i = lineNumHalf - lim(t): lineNumHalf + lim(t)
        tmp = arr(t, i);
        for j = max(i - numHalf, lineNumHalf - lim(t+1)):  min(i + numHalf, lineNumHalf + lim(t+1))
            arr(t+1, j) = arr(t+1, j) + tmp;
        end
    end
end