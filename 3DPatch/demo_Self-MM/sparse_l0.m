function [X, nonZeromap] = sparse_l0(X, threshold)
[~, maxInd] = max(abs(X));
[n, N] = size(X);
% maxVal = X(maxInd);
nonZeromap = (bsxfun(@ge, abs(X), threshold));
base = 0 : n : n*(N - 1);
maxInd = maxInd + base;
nonZeromap(maxInd) = true;
X = X .* nonZeromap;
nonZeromap = sum(nonZeromap)';
end

