%% mian.m
clc;clear;
%parpool(4) 

cover_dir = '/sh3/ysuanbase/home/yeesuan13491/one/base/4000';
stego_dir0 = '/sh3/ysuanbase/home/yeesuan13491/three/stego';

%提取10000副cover图的SRM隐写分析特征
feature_path_c_srm = '/sh3/ysuanbase/home/yeesuan13491/three/Feature/SRM_cover_4000_pgm.mat';

%my_SRM(cover_dir,feature_path_c_srm);%第一次测试代码时运行，之后可以注释掉
% my_SRM_mex(cover_dir,feature_path_c_srm);

% 提取10000副***嵌入负载的stego图的SRM隐写分析特征
payload =[0.3];
feature_path_s_srm = ['/sh3/ysuanbase/home/yeesuan13491/three/Feature/srm_stego_4000_RGMYXT_' num2str(payload*100) '.mat'];
stego_dir = [stego_dir0, '/', num2str(payload * 100)];
my_SRM(stego_dir,feature_path_s_srm);
%[test_error_srm, err_stdr_srm] = my_ensemble_2(feature_path_c_srm,feature_path_s_srm);
 %my_SRM_mex(Output_path,feature_path_s_srm);
delete(gcp)
[test_error_srm, err_stdr_srm] = my_ensemble_2(feature_path_c_srm,feature_path_s_srm);
err_SRM = test_error_srm;
err_SRM_std = err_stdr_srm;


