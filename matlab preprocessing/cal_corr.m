function p = cal_corr(x, y)
p = sum(x.*y)/sqrt(sum(x.^2)*sum(y.^2));