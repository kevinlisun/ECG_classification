function [cleanData eigenval] = denoise_svd(srcData)
len = length(srcData);
sqrtLen = abs(sqrt(len));

srcMat = reshape(srcData, sqrtLen, sqrtLen);
[U,S,V] = svd(srcMat);
eigenval = diag(S);
meanCutPoint = find(eigenval < mean(eigenval));
meanS = S;
meanS(meanCutPoint:end,meanCutPoint:end) = 0;
meanDenoiseMat = U* meanS * V';
cleanData = reshape(meanDenoiseMat, 1, len);