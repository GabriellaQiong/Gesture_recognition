function prob = predict_hmm(O, A, B, Pi)
% PREDICT_HMM() predict the probability of
% Written by Qiong Wang at University of Pennsylvania
% 02/29/2014
%
% INPUTS:
% O    -- Given observation sequence labeled in numerics
% A    -- N x N transition probability matrix
% B    -- N x M Emission matrix
% Pi   -- Initial probability matrix
%
% OUTPUT
% prob -- probability of given sequence in the given model

n = length(A(1,:));             % Number of states
T = length(O);                  % Number of rounds (T)

% Initilization of m
for i = 1 : n        
    m(1,i) = B(i,O(1)) * Pi(i);
end

% Forward algorithm to compute the probability
for t = 1 : T - 1      %recursion
    for j = 1 : n
        z = 0;
        for i = 1 : n
            z = z + A(i,j) * m(t,i);
        end
        m(t + 1, j) = z * B(j, O(t + 1));
    end
end

prob = realmin;
for i = 1 : n         %termination
    prob = prob + m(T, i);        
end
prob = log(prob);
end