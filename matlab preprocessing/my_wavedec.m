function [c,l,aCell cCell] = my_wavedec(x,n,IN3,IN4)
%WAVEDEC Multi-level 1-D wavelet decomposition.
%   WAVEDEC performs a multilevel 1-D wavelet analysis
%   using either a specific wavelet 'wname' or a specific set 
%   of wavelet decomposition filters (see WFILTERS).
%
%   [C,L] = WAVEDEC(X,N,'wname') returns the wavelet
%   decomposition of the signal X at level N, using 'wname'.
%
%   N must be a strictly positive integer (see WMAXLEV).
%   The output decomposition structure contains the wavelet
%   decomposition vector C and the bookkeeping vector L.
%
%   For [C,L] = WAVEDEC(X,N,Lo_D,Hi_D),
%   Lo_D is the decomposition low-pass filter and
%   Hi_D is the decomposition high-pass filter.
%
%   The structure is organized as:
%   C      = [app. coef.(N)|det. coef.(N)|... |det. coef.(1)]
%   L(1)   = length of app. coef.(N)
%   L(i)   = length of det. coef.(N-i+2) for i = 2,...,N+1
%   L(N+2) = length(X).
%
%   See also DWT, WAVEINFO, WAVEREC, WFILTERS, WMAXLEV.

%   M. Misiti, Y. Misiti, G. Oppenheim, J.M. Poggi 12-Mar-96.
%   Last Revision: 30-Jul-2008.
%   Copyright 1995-2008 The MathWorks, Inc.
%   $Revision: 1.15.4.3 $ $Date: 2008/08/22 20:36:54 $

% Check arguments.
if nargin==3
    [Lo_D,Hi_D] = wfilters(IN3,'d');
else
    Lo_D = IN3;   Hi_D = IN4;
end

% Initialization.
s = size(x); x = x(:)'; % row vector
c = [];
l = zeros(1,n+2);
if isempty(x) , return; end

l(end) = length(x);

cCell = cell(n,1);
for k = 1:n
    [x,d] = dwt(x,Lo_D,Hi_D); % decomposition
    c     = [d c];            % store detail
    aCell{k,1} = x;             % store x
    cCell{k,1} = c;             % store c
    l(n+2-k) = length(d);     % store length
end

% Last approximation.
c = [x c];
l(1) = length(x);

if s(1)>1, c = c'; l = l'; end
