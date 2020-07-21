function [ t ] = PSNR3D(X) 
[aa,bb, cc]=size(X);
t=20*log10((sqrt(aa*bb*cc))*255/(norm(X(:),'fro')));
end

