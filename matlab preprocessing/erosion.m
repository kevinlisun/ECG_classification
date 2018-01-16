function y = erosion(x, k)
if size(x, 2)==1
    x = x';
end

if size(k, 2)==1
    k = k';
end

N = length(x);
M = length(k);

Iter = floor(N/M);

tail = M*(Iter+2) - N;
xNew = [x, fliplr(x(end-tail+1:end))];

y = zeros(1, M*(Iter+1));
for m=1:length(xNew)-M
    y(m) = min(xNew(m:m+M-1)-k);
end

y = y(1:N);

