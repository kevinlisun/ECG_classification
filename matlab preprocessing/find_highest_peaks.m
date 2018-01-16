function [peaks, peaksIndex] = find_highest_peaks(sumData, oneLeadData, threshold)

sumData(1) = 0;%32E:\在元智大学\謝瑞建\原始没病\s0461_rem.mat
% sumData(end-100:end) = 0;%32E:\在元智大学\謝瑞建\原始没病\s0461_rem.mat
len = length(sumData);

threshold = threshold*mean(sumData);
threholdData = ones(1, len);
threholdData(sumData<threshold) = 0;



up = find(diff(threholdData) == 1);
upDiff = diff(up);
maxDist = round(0.5*( mean(upDiff)));%ill\s0470_rem.mat need 0.7,
for i=1:length(upDiff)-1;
    if upDiff(i)<maxDist
        upDiff(i+1) = upDiff(i)+upDiff(i+1);
    end
end

threholdData = 0;
threholdData(up(1)) = 1;
threholdData(up(find(upDiff>maxDist)+1)) = 1;


upIndex = find(threholdData == 1);

nbPeaks =  length(upIndex);
peaks = zeros(1, nbPeaks);
peaksIndex = zeros(1, nbPeaks);

for i = 1:nbPeaks-1
    tmp = zeros(1, len);
    tmp(upIndex(i) : upIndex(i)+200) = 1;
    tmp = tmp.*abs(oneLeadData);
    [peaks(i), peaksIndex(i)] = max(tmp);
end

tmp = zeros(1, len);
if upIndex(end)+200>len
    tmp(upIndex(end) : len) = 1;
else
    tmp(upIndex(end) : upIndex(end)+200) = 1;
end
tmp = tmp.*abs(oneLeadData);
[peaks(end), peaksIndex(end)] = max(tmp);
