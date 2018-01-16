function [ result ] = IsNotEqual( h, t)


result = zeros( size(h) );
result(h~=t) = 1;

% weight = 2*weight/sum(weight);
% result = zeros( size(h) );
% 
% result(find(h~=t&t==1)) = weight(1);
% result(find(h~=t&t==-1)) = weight(2);