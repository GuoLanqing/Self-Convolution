function  param   =   getparam(param)
sigma = param.nSig;
param.SearchWin =   30;             % search window size
param.delta     =   0.1;            % noise adding back ratio
param.Innerloop =   2;              % inner loop (control BM freq) size   
if param.searchType == '0'          % 2d block searching
    if sigma<=10                    % sigma = 5,10
        param.PatchSize   =   6;
        param.PatchNO     =   20;
        param.lamada      =   0.54;
        param.Iter        =   1;
        param.dimMatch    =   4;        % TL used #matched
        param.TLthrlist   =   [3.3];
        param.LRthr0            =   1.5;
        param.PatchNOreduce     =   3;
    elseif sigma<=20                    % sigma = 15,20
        param.PatchSize   =   6;
        param.PatchNO     =   20;
        param.lamada      =   0.62;
        param.Iter        =   4;
        param.dimMatch    =   4;        % TL used #matched
        param.TLthrlist   =   [3.0,2.4,2.0,0.8];
        param.LRthr0            =   0.9;
        param.PatchNOreduce     =   3;
    elseif sigma<=50            % sigma = 50
        param.PatchSize   =   7;
        param.dimMatch    =   4;
        param.PatchNO     =   25;
        param.Iter        =   6;
        param.lamada      =   0.56;
        param.TLthrlist   =   [3.0, 2.4, 2.0, 1.2, 1, 0.8];
        param.LRthr0            =   0.9;
        param.PatchNOreduce     =   4;
    else
        param.PatchSize   =   9;
        param.PatchNO     =   30;
        param.Iter        =   14;
        param.lamada      =   0.72;
        param.dimMatch    =   4;
    end
else                                % 3d block searching
    if sigma<=20                    % sigma = 5,10,15,20
        param.PatchSize   =   6;
        param.PatchNO     =   20;
        param.lamada      =   0.56;
        param.Iter        =   4;
        param.dimMatch    =   3;        % TL used #matched
        param.TLthrlist   =   [3.0, 2.4, 2.0, 0.8];
        param.LRthr0            =   1.2;
        param.PatchNOreduce     =   3;
    elseif sigma<=50            % sigma = 50
        param.PatchSize   =   7;
        param.dimMatch    =   4;
        param.PatchNO     =   25;
        param.Iter        =   6;
        param.lamada      =   0.54;
        param.TLthrlist   =   [3.0, 2.4, 2.0, 1.2, 1, 0.8];
        param.LRthr0            =   0.9;
        param.PatchNOreduce     =   4;
    else
        param.PatchSize   =   9;
        param.PatchNO     =   30;
        param.Iter        =   14;
        param.lamada      =   0.72;
        param.dimMatch    =   4;
    end
end
% Param.step      =   floor((Param.PatchSize)/2-1);
param.step      =   1;


% TL parameters
param.maxNumber=param.PatchSize*param.PatchSize*10;
param.noisyWeight = 1e-4 / sigma;

param.alpha=1;
param.isMeanRemoved     =   true;
param.isRecon = true;
param.sparseWeight = 60;

param.n2D = param.PatchSize*param.PatchSize*param.dimMatch;

