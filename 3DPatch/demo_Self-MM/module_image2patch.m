function  [Z, ZT]  =  module_image2patch(Xr,PatchSize)

[H, W, c] = size(Xr); 
PS2 = PatchSize*PatchSize;        
TolPat = (H-PatchSize+1)*(W-PatchSize+1);
Z   = zeros(PS2*c, TolPat, 'single');
if nargout==2,  ZT  = zeros(PatchSize, PatchSize,d, TolPat, 'single'); end

L = 0;      
for i  = 1:PatchSize
    for j  = 1:PatchSize
        L   = L + 1; 
        for t = 1:c
            tmp =  Xr(i:end-PatchSize+i, j:end-PatchSize+j, t);
            Z((t-1)*PS2+L,:) = tmp(:)';                   
            if nargout == 2,     ZT(i,j,t,:) = tmp(:)';       end
        end
    end
end


