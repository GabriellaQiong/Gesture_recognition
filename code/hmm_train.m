function [E, P, Pi, LL] = hmm_train(X, prior, bins, M, maxIter, thresh)
% HMM_TRAIN() trains one  Baum-Welch Hidden Marcov Model by iterating until
% the change in proportion smaller than thresh in loglikelihood
% 
% Written by Qiong Wang at University of Pennsylvania
% 02/29/2014
% 
% INPUT
% X       -- N x p array of Xs, p sequences
% bins    -- possible bins of Xs
% M       -- Number of states                                 (default 2  )
% maxIter -- Maximum number of iterations                     (default 100)
% thresh  -- termination tolerance (prop change in likelihood)(default 1e-5)
%
% OUTPUT
% E    -- observation emission probabilities
% P    -- state transition probabilities
% Pi   -- initial state prior probabilities
% LL   -- log likelihood curve

bins = bins';
numBins = size(bins,1); 
epsi = 1e-10;

% number of sequences
N = size(X,1);
% N = numel(X);

% length of each sequence
T = ones(1,N);
for n = 1 : N,
%   T(n) = size(X{n},2);
  T(n) = size(X{n},1);
end;

TMAX = max(T);

if nargin<6,   thresh = 1e-5; end;
if nargin<5,   maxIter = 100;  end;
if nargin<4,   M      = 2;    end;

fprintf('\n********************************************************************\n');
fprintf('Training %i sequences of maximum length %i from an alphabet of size %i\n',N,TMAX,numBins);
fprintf('HMM with %i hidden states\n', M);
fprintf('********************************************************************\n');

E = (0.1*rand(numBins,M)+ones(numBins,M))/numBins;
E = cdiv(E,csum(E));

%E = (1/num_bins).*ones(num_bins,K);

B = zeros(TMAX,M);

Pi = rand(1,M);
Pi = Pi/sum(Pi);

% transition matrix
P = prior;
P = rdiv(P,rsum(P));

% This is useful if the transition matrix is initialized with many zeros
% i.e. for a left-to-right HMM
P   = sparse(P);
LL  = [];
lik = 0;

for cycle = 1 : maxIter

  % Forward - backward
  Gammainit = zeros(1,M);
  Gammasum  = zeros(1,M);
  Gammaksum = zeros(numBins,M);
  Scale     = zeros(TMAX,1);
  sxi       = sparse(M,M);

  for n = 1 : N
    alpha     = zeros(T(n),M);
    beta      = zeros(T(n),M);
    gamma     = zeros(T(n),M);
    gammaksum = zeros(numBins,M);  

    % Inital values of B = Prob(output|s_i), given data X

    Xcurrent = X{n};
    
    for i = 1 : T(n)
        m = find(bins==Xcurrent(i));
        if (m == 0)
            fprintf('Error: Symbol not found\n');
            return;
        end
        B(i, :) = E(m, :);
    end;

    scale       = zeros(T(n),1);
    alpha(1, :) = Pi(:)'.*B(1, :);
    scale(1)    = sum(alpha(1, :));
    alpha(1, :) = alpha(1, :)/scale(1);
    
    for i = 2 : T(n)
      alpha(i, :) = (alpha(i - 1, :)*P).*B(i, :);
      scale(i)    = sum(alpha(i, :));
      alpha(i, :) = alpha(i, :)/scale(i);
    end;

    beta(T(n), :) = ones(1, M)/scale(T(n));
    for i = T(n) - 1 : -1 : 1
        beta(i, :) = (beta(i + 1, :).*B(i + 1, :))*(P') / scale(i); 
    end;

    gamma = (alpha.*beta) + epsi;
    gamma = rdiv(gamma, rsum(gamma));

    gammasum = sum(gamma);

    for i = 1 : T(n)
      % find the letter in the alphabet
      m = find(bins == Xcurrent(i));
        gammaksum(m,:) = gammaksum(m,:) + gamma(i,:);
    end;

    for i = 1 : T(n) - 1
      t = P.* (alpha(i,:)' * (beta(i + 1,:).*B(i + 1,:)));
      sxi = sxi + t/sum(t(:));
    end;

    Gammainit = Gammainit + gamma(1, :);
    Gammasum  = Gammasum  + gammasum;
    Gammaksum = Gammaksum + gammaksum;

    for i = 1 : T(n) - 1
      Scale(i, :)  = Scale(i,:) + log(scale(i,:));
    end;
    Scale(T(n), :) = Scale(T(n),:) + log(scale(T(n),:));

  end;
  
  %%%% M STEP 
  
  % outputs

  E = cdiv(Gammaksum,Gammasum) + epsi;

  % transition matrix 
  P = sparse(rdiv(sxi,rsum(sxi)));
  P = P*eye(size(P,1));

  % priors
  Pi = Gammainit/sum(Gammainit);

  oldlik = lik;
  lik = sum(Scale);
  LL = [LL lik];
  fprintf('\ncycle %i log likelihood = %f ',cycle,lik);  
  if (cycle<=2)    likbase=lik;
  elseif (lik<(oldlik - 1e-6))     fprintf('Not change so much');
  elseif ((lik-likbase)<(1 + thresh)*(oldlik-likbase)||~isfinite(lik)) 
    fprintf('\nDone\n');    return;
  end;
end