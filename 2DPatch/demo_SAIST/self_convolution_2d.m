function  pos_arr   =  self_convolution_2d(im, par)

%PROCESSSTATIC Summary of this function goes here
%   Detailed explanation goes here
% Goal : self-convolution to replace original block matching (searching K most similar patches of each reference patch)
% Inputs:
%   1. im      : image, Height*Width
%   2. par             : parameters
%      - win           : search winodw size
%      - step          : step of extracting patches
%      - nblk          : number of similar patches (K)
% Output:
%   1. pos_arr         : K most similar patches for every reference patch
%   within search window, par.nblk*num_patches
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

S         =   30;
f         =   par.win;
s         =   par.step;

N         =   size(im,1)-f+1;
M         =   size(im,2)-f+1;
r         =   [1:s:N];
r         =   [r r(end)+1:N];
c         =   [1:s:M];
c         =   [c c(end)+1:M];
L         =   N*M;
X         =   zeros(f*f, L, 'single');

k    =  0;
for i  = 1:f
    for j  = 1:f
        k    =  k+1;
        blk  =  im(i:end-f+i,j:end-f+j);
        X(k,:) =  blk(:)';
    end
end

% Index image
I     =   (1:L);
I     =   reshape(I, N, M);
N1    =   length(r);
M1    =   length(c);
pos_arr   =  zeros(par.nblk, N1*M1 );
Patnorm = 0.5*(vecnorm(X)).^2;

for  i  =  1 : N1
    for  j  =  1 : M1
        
        row     =   r(i);
        col     =   c(j);
        off     =  (col-1)*N + row;
        off1    =  (j-1)*N1 + i;
                
        rmin    =   max( row-S, 1 );
        rmax    =   min( row+S, N );
        cmin    =   max( col-S, 1 );
        cmax    =   min( col+S, M );
         
        idx     =   I(rmin:rmax, cmin:cmax);
        Subimage = im(rmin:rmax+f-1, cmin:cmax+f-1);
        idx     =   idx(:);
        Subpatnorm = Patnorm(idx);
        D = conv2(Subimage,rot90(reshape(X(:,off),f,[])',2),"valid");
        dis = Subpatnorm - D(:)'; 
        
        [val,ind]   =  sort(dis);        
        pos_arr(:,off1)  =  idx( ind(1:par.nblk) );        
    end
end