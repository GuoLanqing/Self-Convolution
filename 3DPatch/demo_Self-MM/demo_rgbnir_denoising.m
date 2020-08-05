clear all;
sigma = 10;
load('./data/RGB-NIR/016.mat');
addpath('../')
% test
imcat_AB = imcat_AB(1:200,1:200,:);

clean=double(imcat_AB);
[Height, Width, Ch] = size(clean);

% add noise
randn('seed',0);
noisy           =   double(clean) + sigma * randn(size(clean));

param.searchType = '0'; % 2d patch searching
param.nSig = sigma;
param.patchChannel = Ch;  % patch channels
param= getparam(param);

param.noiseEstFlag          =   false;
Xr                          =   noisy;
PatchSize                   =   param.PatchSize;
noisyPatch                  =   module_image2patch(noisy, PatchSize);           %   noisy patches


% TL threshold 
TLthrList               =   param.TLthrlist;

param.learningIter      =   20;
param.func              =   @(X, threshold) sparse_l0(X, threshold);
buffer.YXT=zeros(param.n2D*Ch,param.n2D*Ch);
buffer.D=kron(...
    kron(kron(dctmtx(param.PatchSize), dctmtx(param.PatchSize)), dctmtx(Ch)), ...
    dctmtx(param.dimMatch));
tic;
for iter = 1 : param.Iter
    % adding back noise -> Input
    Xr                      =	Xr + param.delta*(noisy - Xr);
    inputPatch              =   module_image2patch(Xr, PatchSize);  % input patch
    % estimate noise if iter > 1
    % use initial sigma, if iter == 1
    if iter > 1
        param.noiseEstFlag        =    true;
    end
    % every other Innerloop
    if (mod(iter-1,param.Innerloop)==0)
        param.PatchNO           =   param.PatchNO - param.PatchNOreduce;
        param.PatchNOsqrt       =   sqrt(param.PatchNO);
        [idxBM, GridX,GridY]    =   self_convolution_2d(Xr,inputPatch, param, Height, Width);
        keyPatch_arr            =   idxBM(1, :);
    end
    
    % LR approx
    [patch_LR, weight_LR]   =   ...
        module_LRapprox(inputPatch, idxBM ,noisyPatch, param, GridX, GridY);
    [Xr_LR, Weight_LR]      =   ...
        module_patch2image(patch_LR, weight_LR, PatchSize, Height, Width, Ch);
    Xr_LR               =   Xr_LR ./(Weight_LR + eps);
    psnr_LR             =   PSNR3D( clean - Xr_LR);
    
    % TL approx
    param.TLthr0            =   TLthrList(iter);
    [ patch_TL, weight_TL] = ...
        module_TLapprox(idxBM, keyPatch_arr, inputPatch, noisyPatch, param, buffer);
    [Xr_TL, Weight_TL]  = ...
        module_patch2image(patch_TL, weight_TL, PatchSize, Height, Width, Ch);
    Xr_TL               =   Xr_TL ./(Weight_TL + eps);
    psnr_TL             =   PSNR3D( clean - Xr_TL);
    
    % fusion
    Xr          =       0.5 * (Xr_LR + Xr_TL);
    psnrXr      =       PSNR3D( clean - Xr);
    fprintf( 'Self-MM, iter = %2.2f, PSNR = %2.2f. \n', iter, psnrXr);
end
denoisetime=toc;
%%%%%%%%%%%%%%%%%%%%%%%
fprintf( 'Denoising finish, with iter = %2.2f, and psnr = %2.2f \n', iter, psnrXr);
