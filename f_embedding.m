function [stego,dist,My_seed] = f_embedding(cover, costmat, payload,H,params,WET,randseed)
if H==0
    [stego,dist,My_seed]= f_sim_embedding(cover,costmat,payload, params,WET,randseed);
else
   [ stego,dist]= f_stc_embedding(cover, costmat, payload,WET);
end
%根据H熵的大小选择嵌入函数
%如果所有的概率都接近于0或1，说明我们几乎可以肯定地预测系统的状态
% ，在这种情况下，熵接近于0，代表很小的不确定性。
%如果三种状态的概率相对平均（例如，都接近于三分之一），那么熵值会更高，
% 代表较大的不确定性。这意味着从这样的系统中观察到一个状态提供了更多的"新信息”，
% 因为预测该状态的难度更大。