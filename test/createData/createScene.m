function [pro, S] = createScene(data, K)

% data = [2109	2159	2036	2031	2046	2248	2279	2194	2175	2281	2514	2206	2227	2308	2175	1850	1523	1000	1200	900	1200	1000	800	500];
% K = 10;

tNum = size(data, 2);
sceneNum = 1000;

% 场景生成
scene = data .* (1 + 0.28 * normrnd(0,1,sceneNum, tNum)) ;

% 场景削减
[idx, S] = kmedoids(scene, K);
% plot(S');
pro = zeros(K, 1);
for i = 1: K
    pro(i) = sum(idx == i) / sceneNum;
end


