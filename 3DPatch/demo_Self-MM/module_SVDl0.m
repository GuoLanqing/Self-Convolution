function  [X] =  module_SVDl0( Y, thr0, sigma, param)
% SVD   
[U,SigmaY,V] =  svd((Y),'econ');    
% threshold
thr         =   thr0 * sigma * (param.PatchNOsqrt + param.PatchSize);
idx         =   find(SigmaY>thr);

svp         =   length(idx);
SigmaX      =   SigmaY(idx);
X           =   U(:,1:svp)*diag(SigmaX)*V(:,1:svp)';
end