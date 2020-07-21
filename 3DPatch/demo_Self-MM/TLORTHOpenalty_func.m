function updateBuffer= TLORTHOpenalty_func(thr, buffer, blocks, param)
YXT                 =   buffer.YXT;
D                   =   buffer.D;
alpha               =   param.alpha;
% thr                 =   param.TLthr0;                % sparse coding threshold
sparseWeight        =   param.sparseWeight;

% (1) sparse coding
X1 = D * blocks;      
% X2 = X1.*(bsxfun(@ge,abs(X1),thr));
X2 = sparse_l0(X1, thr);
% (2) accumulate YX'
YXT = alpha * YXT + (blocks * X2');
% (3) svd
[U, ~, V] = svd(YXT);
% (4) Update D
D = V * U';
if isfield(param, 'isRecon') && param.isRecon
    % sparse coding with updated D
    X1 = D * blocks;
    %  enforce sparsity >= 1
    [X2, scores] = sparse_l0(X1, thr);
    updateBuffer.sparsity = scores;
    scores = sparseWeight ./ scores;  
    updateBuffer.TLaproxError = sum((X2 - X1).^2);
    % recon
    blocks = D' * X2;
    updateBuffer.blocks = blocks;               % instantaneous recon.
    updateBuffer.scores = scores;
end

updateBuffer.YXT = YXT;
updateBuffer.D = D;
end

