function  [NLBLK, GridX,GridY]  =  self_convolution_2d(Xr, X, Param, Height, Width)

%PROCESSSTATIC Summary of this function goes here
%   Detailed explanation goes here
% Goal : self-convolution to replace original block matching (searching K most similar patches of each reference patch)
% Inputs:
%   1. Xr      : Height*Width*Channels
%   2. X            : extracted patches, patch_size*num_patches
%   3. param             : parameters
%      - PatchNO         : number of similar patches (K)
%      - step            : step of extracting patches
%      - PatchSize       : size of image patch
%      - SearchWin       : size of search window
% Output:
%   1. NLBLK     : K most similar patches for every reference patch
%   within search window, param.PatchNO*num_patches
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PatchNO  = 30;          PatchSize  = 8;  SW  = 20; s = 1; 
if isfield(Param,'PatchNO'),        PatchNO    = Param.PatchNO;    end
if isfield(Param,'PatchSize'),      PatchSize  = Param.PatchSize;  end
if isfield(Param,'SearchWin'),      SW         = Param.SearchWin;  end
if isfield(Param,'step'),           s          = Param.step;       end
ImClipH   =   Height - PatchSize +1;
ImClipW   =   Width  - PatchSize +1;

GridX	=   1:s:ImClipH;
GridX	=   [GridX GridX(end)+1:ImClipH];
GridY	=   1:s:ImClipW;
GridY	=   [GridY GridY(end)+1:ImClipW];

Idx     =   (1:ImClipH*ImClipW);
Idx     =   reshape(Idx, ImClipH, ImClipW);
LGridH  =   length(GridX);    
LGridW  =   length(GridY); 

NLBLK   = zeros(PatchNO, LGridH * LGridW);
Patnorm=0.5*vecnorm(X).^2;
for  i  =  1 : LGridH
    for  j  =  1 : LGridW    
        x      =   GridX(i);              y      =   GridY(j);
        top    =   max( x-SW, 1 );        button =   min( x+SW, ImClipH );        
        left   =   max( y-SW, 1 );        right  =   min( y+SW, ImClipW );     
        
        kk     =  (j-1)*LGridH + i;
        NL_Idx =   Idx(top:button, left:right);
        NL_Idx =   NL_Idx(:);
        
        RefPatch  = X(:,(y-1)*ImClipH + x);
        
        % 3d search window
        tempSW = Xr(top:button+PatchSize-1, left:right+PatchSize-1,:);
        
        % 3d reference patch
        RefPatch = rot90(flipud(reshape(RefPatch,PatchSize,PatchSize,[])),3); 
        RefPatch = rot90(flip(RefPatch,3),2);
        
        D=convn(tempSW,RefPatch,"valid");
        SubPatnorm=Patnorm(NL_Idx);
        D=SubPatnorm-D(:)';

        [v, idx]    = sort(D);
        NLBLK(:,kk) = NL_Idx(idx(1:PatchNO));
    end
end
