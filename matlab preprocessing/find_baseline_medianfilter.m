function [baseline noBaselineData] = find_baseline_medianfilter(srcData, windowSize)

assert(rem(windowSize-1, 2) == 0); %assume windowSize is a odd
head =  fliplr(srcData(1:1000));
tail = fliplr(srcData(end-1000:end));

newData = cat(2, head, srcData, tail);

lenHead = length(head);
lenTail = length(tail);
Len = length(newData);

% newData(1:(1+windowSize)/2) = newData(1);
% newData((5+windowSize)/2:((3+windowSize)/2+Len)) = newData(1:Len);
% newData(((5+windowSize)/2+Len): Len+windowSize-1) = newData(Len);
% 
% BL = zeros(1,Len);
% for i = 1:Len
%     BL(i) = median(newData(i:i+windowSize-1));
% %     baseline(i) = mean(newData(i:i+windowSize-1));
% end
% % % % baseline(1:300) = baseline(300);
% % % % baseline(end-300:end) = baseline(end-300);
% % % % noBaselineData = newData - baseline;

%%%==========
BL = fastmedfilt1d(newData, windowSize);
%%%==========

baseline = BL(lenHead+1:Len-lenTail);
noBaselineData = srcData - baseline;


