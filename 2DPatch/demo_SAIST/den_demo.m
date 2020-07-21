% demo program for comparing BM3D, BM3DSAPCA and LASSC

imdir=dir('C:\Users\X Li\Dropbox\bounds_toolbox\images\*.png');
addpath('C:\Users\X Li\Dropbox\bounds_toolbox\images\');
sigma_list=[25,50,100];

for i=1:length(imdir)
%for i=4:5
    for j=1:length(sigma_list)
        fprintf('i=%d,j=%d\n',i,j);
    x=double(imread(imdir(i).name));
    sigma=sigma_list(j);
    y=x+randn(size(x))*sigma;
    [psnr_temp,x_bm3d]=BM3D(x/255,y/255,sigma);
    %tic;x_est = BM3DSAPCA2009(y/255,sigma/255);toc;
    x_saist=Image_LASSC_Denoising(y,x,sigma);
    %x_oracle=Image_LASSC_Denoising_adapt(y,x,sigma);
    %x_saist2=Image_LASSC_Denoising2(y,x,sigma,7,15);
    psnr_bm3d(i,j)=10*log10(255*255/var(x(:)-x_bm3d(:)*255));
    %psnr_est(i,j)=10*log10(255*255/var(x(:)-x_est(:)*255));
    psnr_saist(i,j)=10*log10(255*255/var(x(:)-x_saist(:)));
    %psnr_oracle(i,j)=10*log10(255*255/var(x(:)-x_oracle(:)));
    %fprintf('BM3D=%f,SAPCA=%f,SAIST=%f\n',psnr_bm3d(i,j),psnr_est(i,j),psnr_saist(i,j));
    fprintf('BM3D=%f,SAIST=%f\n',psnr_bm3d(i,j),psnr_saist(i,j));
    end
end

%save den_results

% i=5:10:25;
% k=2;
% plot(i,255*255./(10.^(psnr_bm3d(k,:)/10)),'+-',i,255*255./(10.^(psnr_est(k,:)/10)),'*-',i,255*255./(10.^(psnr_saist(k,:)/10)),'o-',i,Q,':');
% xlabel('noise standard deviation');
% ylabel('MSE');