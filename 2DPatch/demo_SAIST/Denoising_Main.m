% clc;
clear;
%addpath('Utilities');
Test_image_dir     =    'Data\Denoising_test_images';


%----------------------------------------------------------
% Experiment 1
%----------------------------------------------------------
Out_dir        =    'Results\Denoising_results\';
levels         =   [20];

for  idx  =  1 : length(levels)
    
    pre           =   sprintf('nsig_%d', idx);
    Res_dir       =   strcat(Out_dir, pre);
    nSig          =   levels(idx);    
    tic;
    par = Image_Denoising(nSig, Res_dir, Test_image_dir);    
    denoisetime=toc;
end



 