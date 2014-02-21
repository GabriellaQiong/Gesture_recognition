function [q, rots] = ukf_estimate(acc, vel, P, Q, R, ts)
% UKF_ESTIMATE() fuses the data from both accelerometer and gyroscope and
% give estimation of orientation through Uncented Kalman Filter
%
% Written by Qiong Wang at University of Pennsylvania
% 02/07/2014
% Refer to Kraft's paper: http://hep1.physik.uni-bonn.de/fileadmin/Publications/Mqube/Kraft_FusionPaperWeb.pdf
%
% INPUT (N is the number of data points)
% acc, vel -- 3 x N acceleration and angular velocity
% P, Q, R  -- 3 x 3 covariance matrix
%             P : state covariance matrix              (time t)
%             Q : process noise matrix                 (time t -> time t+1)
%             R : measurement/observation noise matrix (time t measure)
% ts       -- 1 x N time stamp
%
% OUTPUT
% q        -- N x 4 quaternion matrix
% rots     -- 3 x 3 x N rotation matrix

% Initialize
n       = 3;
datNum  = size(acc, 2);
q       = zeros(datNum, 4);
rots    = zeros(3, 3, datNum);
x       = [1 0 0 0]';                  % Initial state vector in vector
thresh  = 1e-3;      
maxIter = 100;

% Precompute
deltaT  = ts - [ts(1), ts(1 : end - 1)];
velNorm = sqrt(sum(vel.^2, 1));
angle   = velNorm .* deltaT;
axis    = bsxfun(@rdivide, vel, velNorm); 
qDelta  = [cos(angle / 2)' transpose(bsxfun(@times, axis, sin(angle / 2)))];

% UKF filter
for i = 1: datNum
%     fprintf('Processing data point # %d...\n', i);
    % Sigma Points (P -- 3 x 3, n = 3, 6 sigma points)
    P  = P + 1e-10 * eye(3);
    S  = chol(P + Q);
    W1 = S * sqrt(2 * n);
    W  = [W1, -W1];
    
    % Quaternion Sigma Points
    X  = mat2quat(W);         % 6 x 4
    
    % Transformation of Sigma Points
    q0 = quatmultiply(x', X);
    Y  = quatnormalize(quatmultiply(q0, qDelta(i, :)));
    
    % Computation of Mean (Gradient Descent)
    iter    = 0;
    s       = x';
    errNorm = 1;   
    
    while (errNorm >= thresh && iter < maxIter)
        errQuat = quatmultiply(Y, quatinv(s));
        errVec  = quat2mat(errQuat);
        errMean = mean(errVec, 2);
        errQuat = mat2quat(errMean);
        errNorm = sqrt(sum(errMean.* errMean, 1));
        s       = quatmultiply(errQuat, s);
        iter    = iter + 1;
    end
    
    % Computation of Covariance
    % (1) A Priori State Vector Covariance
    x_  = s';
    Wp  = errVec;
    P_  = cov(Wp');                          % cov() between columns
    
    % (2) Measurement Estimate Covariance
    Z   = quat2mat(quatmultiply(Y, quatmultiply([0 0 0 1], quatinv(Y))));
    z_  = mean(Z, 2);
    z   = acc(:, i);
    v   = z - z_;    
    Pzz = cov(Z');
    Pvv = Pzz + R;
    
    % (3) Cross correlation matrix
    Pxz  = zeros(3);
    Zabs = bsxfun(@minus, Z, z_);
    for j = 1 : 2 * n
        Pxz = Pxz + Wp(:, j) * Zabs(:, j)';
    end
    Pxz = Pxz / 2 / n;
    
    % Kalman Gain and Update
    K = Pxz / Pvv;
    x = transpose(quatmultiply(x_', mat2quat(K * v)));
    P = P_ - K * Pvv * K';
%     P = P_;
    
    % Record data
    q(i, :)       = x;
    rots(:, :, i) = quat2dcm(q(i, :));
end