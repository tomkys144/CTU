function [a] = ar_fit_model(y, p)
% function [a] = ar_fit_model(y,p)
%
% INPUT:
% y : N-by-1 vector, sound signal
%
% p : required order of AR model
%
% OUTPUT:
% a: (p+1)-by-1 vector, estimated parameters of AR model 
% 
% ordering of vector *a* is such that: 
%   a(1) = a_0 [ from Eq. (2) in this Task description ]
%   a(2) = a_1 [ from Eq. (2) in this Task description ]
%   .
%   .
%   a(p+1) = a_p [ from Eq. (2) in this Task description ]
%
% M, b: matrix and vector as in the Task description, 
%       M*a = b (in LSQ sense) 
% discard the code from here and implement the functionality:


T = length(y);

M = zeros(p);
textprogressbar('Calculating matrix M:')
for t=1:T-p
    M(t,1) = 1;
    textprogressbar(t/(T-p)*100)
    for i=1:p
        M(t,1+i) = y(t-i+p);
    end
end
textprogressbar('Done')
y_pred = y(p+1:end);
a = M\y_pred;
end
