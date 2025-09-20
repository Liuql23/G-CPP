function rho = MySCPP_0320(cover)
%% 参数设置
params = 438; 
WET = single(1e10);
H=0; 

payload=single(0.3);
%% 读取空域灰度图
%coverPath = fullfile('./', 'cover_pgm', '1013.pgm');
%cover = double(imread(coverPath));
MEXstart = tic;
rho1 = my_MiPOD(cover,payload);
rho2= Hill(cover);
 
% Ps1 = Ps_EmbeddingSimulator(cover, rho1, payload);
% Ps2 = Ps_EmbeddingSimulator(cover, rho2, payload);
% MEXend = toc(MEXstart);
%% Embedding simulator
My_seed = params;
[stego1,Ps1,My_seed] = f_embedding(cover, rho1, payload, H,My_seed,WET,1);
[stego2,Ps2,My_seed] = f_embedding(cover, rho2, payload, H,My_seed,WET,0);
%stege1=double(stego1);
%stego2=double(stego2);
%% 找到所有争议像素
Ps = cat(3, Ps1, Ps2);
Y = var(Ps, 0, 3);
Ps_th = Getting_threshold(Y,0.23*payload);
index_0 = find(Y>Ps_th);
% index_coords = [index_rows, index_cols];
%Ps_new=(Ps1+Ps2)/2;
Ps_new=Ps1;
%% 第一等级像素位置(+1/-1)-->(-1/+1)并更新概率值
diff = abs(stego1-stego2);
index_1 = find(diff == 2);
%HW_var =  fspecial('average',[3 3]);%可有可无 可修改  3 11
% 找到重合的位置
overlap_1 = intersect(index_1, index_0);
if (~isempty(overlap_1))
    ep1 = zeros(size(cover));
    ep1(overlap_1) = Y(overlap_1).*2.0; % 将此类像素的标准差扩大两倍
    %ep1 = imfilter(ep1, HW_var ,'symmetric','same');
    Ps_new = Ps_new.*exp(ep1);
end
%% 第二等级像素位置(0)-->(+1/-1)并更新概率值
diff1 = abs(stego1 - cover); % WOW
diff2 = abs(stego2 - cover); % SUNIWEARD
index_02_2 = find(diff2(index_0)==0);
index_02_1 = find(diff1(index_0)~=0);
overlap_2 = intersect(index_02_2,index_02_1);

if (~isempty(overlap_2))
    ep2 = zeros(size(cover));
    ep2(overlap_2) = Y(overlap_2).*1.3; % 将此类像素的标准差扩大1.5倍
   % ep2 = imfilter(ep2, HW_var ,'symmetric','same');
    Ps_new = Ps_new.*exp(ep2);
end

%% 第三等级像素位置(+1/-1)-->0并更新概率值
index_03_2 = find(diff2(index_0) ~= 0);
index_03_1 = find(diff1(index_0) == 0);
overlap_3 = intersect(index_03_2,index_03_1);
if (~isempty(overlap_3))
    ep3 = zeros(size(cover));
    ep3(overlap_3) = Y(overlap_3); % 将此类像素的标准差不变
   % ep3 = imfilter(ep3, HW_var ,'symmetric','same');
    Ps_new = Ps_new.*exp(ep3);
end
% 更新 Ps 中对应位置的值
Ps=Ps_new/2;
Ps(Ps>2/3)=2/3;
% Ps = Ps./max(Ps(:))*2/3;
rho = log(1./Ps- 2);
rho(rho>1e13)=1e13;
HW =  fspecial('average',[15 15]);%可有可无 可修改  3 11
rho = imfilter(rho, HW ,'symmetric','same');
MEXend = toc(MEXstart);
%% Embedding simulator
[stego,Pchange,~] = f_embedding(cover, rho, payload, H,My_seed,WET,0);
end

