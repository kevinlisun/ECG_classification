function x = my_idct(y, a, b)
N = length(y);
w(1) = 1/sqrt(N);
w(2:b) = w(1)*sqrt(2);

x = zeros(size(y));

for k = a:b
    for n = 1:N
        x(n) = x(n)+w(k)*y(k)*cos(pi*(2*n-1)*(k-1)/2/N);
    end
end

