clc
clear

data = [2109	2159	2036	2031	2046	2248	2279	2194	2175	2281	2514	2206	2227	2308	2175	1850	1523	1000	1200	900	1200	1000	800	500];
sceneNum = 1000;
sceneReduceNum = 10;
tNum = size(data, 2);

scene = data .* (1 + 0.25 * normrnd(0,1,sceneNum, tNum)) ;

[idx,C,sumd, D] = kmedoids(scene, sceneReduceNum);
plot(C');
for i = 1: sceneReduceNum
    pro(i) = sum(idx == i) / sceneNum;
end


% sceneDistance = zeros(sceneNum);
% for i = 1: sceneNum-1
%     for j = i+1: sceneNum
%         sceneDistance(i, j) = sum((scene(i) - scene(j)) .^ 2);
%         sceneDistance(j, i) = sceneDistance(i, j); 
%     end
% end


% scenePro = ones(1, sceneNum) / sceneNum;
% for i = 1: sceneNum - sceneReduceNum
%     [~, k] = min(sum(scenePro * scenePro' .* sceneDistance));
%     
%     kDistance = sceneDistance(k, :);
%     kDistance(k) = [];
%     [~, l] = min(kDistance);
%     if (l >= k)
%         l = l + 1;
%     end
%     
%     scenePro(l) = scenePro(l) + scenePro(k);
%     scenePro(k) = [];
%     sceneDistance(k, :) = [];
%     sceneDistance(:, k) = [];
% end