function [stego,Pchange,My_seed] = f_sim_embedding(cover, costmat, payload, params,WET,randseed)
%参数：原始图像 成本矩阵 嵌入负载 参数

%% Get embedding costs
% inicialization 初始化
cover = double(cover);
seed = params; %% seed for location selection 种子位置选择
wetCost = WET;%定义一个非常大的成本
% compute embedding costs \rho 计算嵌入成本
rhoA = costmat;
rhoA(rhoA > wetCost) = wetCost; % threshold on the costs 把比wetcost大的成本设置成wetcost
% if all xi{} are zero threshold the cost 把不是数值的成本像素点赋极高的代价值
rhoA(isnan(rhoA)) = wetCost; 
rhoP1 = rhoA;
rhoM1 = rhoA;
%把像素值为255的像素点赋予极高的代价值，因为255为像素值最大值，无法再+1
rhoP1(cover==255) = wetCost; % do not embed +1 if the pixel has max value
%把像素值为0的像素点赋予极高的代价值，因为0为像素值最小值，无法再-1
rhoM1(cover==0) = wetCost; % do not embed -1 if the pixel has min value
%通过嵌入模拟器嵌入信息
[stego,Pchange,My_seed] = f_EmbeddingSimulator_seed(cover, rhoP1, rhoM1, payload*numel(cover),seed,randseed); 


          
