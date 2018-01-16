function baseline = threshold_fit(srcData, n, order, peaksDirction)
assert(strcmp(peaksDirction, 'up') || strcmp(peaksDirction, 'down'));


head =  fliplr(srcData(1:500));
tail = fliplr(srcData(end-500:end));
srcData = cat(2, head, srcData, tail);

lenHead = length(head);
lenTail = length(tail);

len = length(srcData);
sz = size(srcData);
x = (1: len);
if sz(2)==1
    x = x';
end
y = srcData;


if n > 0
    p = polyfit(x, y, order);
    baseline = polyval(p,x);
    %%%%=====
%     xx = 1:10:length(x);
%     baseline = spline(xx, y(xx), x);
    %%%%=====
    if strcmp(peaksDirction, 'up')
        threshData = srcData;
        threshData(find(srcData > baseline)) = baseline(find(srcData > baseline));
        baseline = threshold_fit(threshData, n-1, order, 'down');
    end
    
    if strcmp(peaksDirction, 'down')
        threshData = srcData;
        threshData(find(srcData < baseline)) = baseline(find(srcData < baseline));
        baseline = threshold_fit(threshData, n-1, order, 'up');
    end
else
    baseline = srcData;
end
baseline = baseline(lenHead+1:len-lenTail);
