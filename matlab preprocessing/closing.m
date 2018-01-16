function y = closing(x, k)
if size(x, 2)==1
    x = x';
end

if size(k, 2)==1
    k = k';
end


y = dilation(x, k);
y = erosion(y, k);