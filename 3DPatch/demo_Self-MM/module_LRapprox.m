function [output, weights] = ...
    module_LRapprox(input, idxBM, noisy, param, GridX, GridY)

output          =   zeros(size(input));
numMatch        =   size(idxBM, 1);
patchDim        =   param.PatchSize * param.PatchSize;
weights         =   zeros(1, size(input, 2), size(input,3));
LGridH          =   length(GridX);    
LGridW          =   length(GridY); 
pc              =   param.patchChannel;

for  i  =  1 : LGridH
    for  j  =  1 : LGridW    
        kk          =   (j-1)*LGridH + i;            % index of key patches
        curMatrix   =   input(:, idxBM(:,kk)); 
        noisyMat    =   noisy(:, idxBM(:,kk));
        % vectorize the 3D space
        curMatrix   =   reshape(curMatrix, patchDim, pc * numMatch);
        noisyMat    =   reshape(noisyMat, patchDim, pc * numMatch);
        if param.noiseEstFlag         
            sigma   =   param.lamada*sqrt(abs(param.nSig^2-mean((curMatrix(:)-noisyMat(:)).^2)));
        else 
            sigma   =   param.nSig;
        end
        % de-mean
        MeanMat     =   mean(curMatrix, 2);
        curMatrix   =   bsxfun(@minus, curMatrix, MeanMat);
            
        ReconMat 	=   module_SVDl0(curMatrix, param.LRthr0, sigma, param); 
        
        % re-mean
        ReconMat    =   bsxfun(@plus, ReconMat, MeanMat);

        % revert to 3D image
        ReconMat    =   reshape(ReconMat, patchDim *pc, numMatch);
        
        output(:,idxBM(:,kk))  = output(:,idxBM(:,kk)) + ReconMat;   
        weights(1, idxBM(:,kk))  = weights(1, idxBM(:,kk)) + 1;
    end
end