function y = opening(x, k)
if size(x, 2)==1
    x = x';
end

if size(k, 2)==1
    k = k';
end

y = erosion(x, k);
y = dilation(y, k);