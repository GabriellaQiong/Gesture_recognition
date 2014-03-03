function P = set_prior(M, LR)
% SET_PRIOR() sets the prior for the transition matrix
% Written by Qiong Wang at University of Pennsylvania
% 02/29/2014
%
% INPUT
% M  -- Number of symbols
% LR -- Allowable number of left-to-right transitions

P = ((1/LR)) * eye(M);

for i = 1 : M - (LR-1)
    for j = 1 : LR-1
        P(i, i+j) = 1/LR;
    end
end

for i = M - (LR-2) : M
    for j = 1 : M - i + 1
        P(i, i + (j - 1)) = 1/(M - i + 1);
    end
end