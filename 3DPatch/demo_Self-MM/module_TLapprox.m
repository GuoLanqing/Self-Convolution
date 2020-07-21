function [ patchRecon, Weight, W] = module_TLapprox(idxBM, keyPatch_arr, patches, Y, param, buffer )

patchRecon        =   zeros(size(patches));
Weight          =   zeros(1, size(patches, 2),size(patches, 3));
% Parameters
func                        =   param.func;         % shrinkage
learningIter                =   param.learningIter;
TLthr0                      =   param.TLthr0;
dimMatch                    =   param.dimMatch;         % transform dim on BM
n2D                         =   size(patches, 1);
n                           =   n2D * dimMatch;
maxNumber=param.maxNumber;
TLstart=1;
currData=0;
numTotal=length(keyPatch_arr);
for  k      =  1 : numTotal
    currData=currData+1;
    curTensorInd=idxBM(1:dimMatch, k);
    curMatrix       =   patches(:, curTensorInd);
    if param.noiseEstFlag
        % noise estimate
        noisyMat    =   Y(:, idxBM(1:dimMatch,k));
        sigma       =   param.lamada*sqrt(abs(param.nSig^2-mean((curMatrix(:)-noisyMat(:)).^2)));
    else
        sigma       =   param.nSig;
    end
    
    miniblocks(:,currData)=curMatrix(:);
    if((currData==maxNumber)||k==length(keyPatch_arr))
        if(k==length(keyPatch_arr))
            miniblocks=miniblocks(:,1:currData);
        end
        
        % TL approximate
        threshold       =   sigma * TLthr0;
        buffer = ...
            TLORTHOpenalty_func(threshold, buffer, miniblocks, param);
        denoisedBlock           =   buffer.blocks;
        denoisedBlock(denoisedBlock < 0)    =   0;
        denoisedBlock(denoisedBlock > 255)  =   255;
        TLscores            =   buffer.scores;
        denoisedBlock           =   bsxfun(@times, denoisedBlock, TLscores');
        for jj   =   TLstart : k
            curTensorInd    =   idxBM(1:dimMatch,jj);
            idxMini         =   jj - TLstart + 1;
            curTensor       =   reshape(denoisedBlock(:, idxMini), n2D, dimMatch);
            curWeight       =   TLscores(idxMini);
            patchRecon(:, curTensorInd)   =   ...s
                patchRecon(:, curTensorInd) + curTensor;
            Weight(:, curTensorInd)         =   Weight(:, curTensorInd) + curWeight;
        end 
        TLstart         =   k + 1;
        currData        =   0;
    end
end
end
