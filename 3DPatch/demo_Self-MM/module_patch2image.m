function  [Y, weight]  =  module_patch2image(Z, weightZ, PatchSize, H, W, c)
    
H2   =   H - PatchSize + 1;          
W2   =  W - PatchSize + 1;
OffR =   0:H2-1;                     
OffC =  0:W2-1;    


Y  	 =  zeros(H, W, c);
weight  =   zeros(H, W, c);
L    =   0;
weightZ = reshape(weightZ, [H2, W2]);

for channel = 1 : c
    for i  = 1:PatchSize
        for j  = 1:PatchSize
            L = L + 1;
            tmp = Z(L,:); %row, should be rearrange as image       
            Y(OffR+i,OffC+j, channel)  =  Y(OffR+i,OffC+j, channel) + reshape(tmp, [H2 W2]);
            weight(OffR+i,OffC+j, channel)  =  weight(OffR+i,OffC+j, channel) + weightZ;
        end
    end
end


