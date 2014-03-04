% Run Script for Project 3 Gesture Recognition, ESE 650
% Written by Qiong Wang at University of Pennsylvania
% 02/26/2014

%% Clear up
clearvars -except trainData testData;
close all;
clc;

%% Flags
check   = false;                     % Whether to do sanity check
verbose = false;                     % Whether to show the details
test    = true;                      % Whether to test

%% Paths
scriptDir = fileparts(mfilename('fullpath'));
trainDir  = '/home/qiong/ese650_data/project3/train';
testDir   = '/home/qiong/ese650_data/project3/test';
outputDir = fullfile(scriptDir, '../results');
if ~exist(outputDir, 'dir')
    mkdir(outputDir); 
end
addpath(genpath('../code'));

%% Load data
trainFile = fullfile(scriptDir, '../data', 'train_data.mat');
trainData = load_data(trainDir, trainFile, 'train');
% trainData = trainData.data;
numTrain  = numel(trainData);

%% Parameters
D         = 3;                         % Number of dimensions to use: X, Y, Z
M         = 4;                         % Number of output symbols
N         = 20;                        % Number of clusters
LR        = 2;                         % Degree of play in the left-to-right HMM transition matrix 
cycle     = 70;
thresh    = 1e-6;

%% Train Hidden Marcov Model
% Initialize
centroids = zeros(N, D, M);
E         = zeros(M, N, M);
% E         = zeros(N, M, M);
P         = zeros(M, M, M);
Pi        = zeros(1, M, M);
ATrain    = cell(M, 1);
LL        = cell(M, 1);

for i = 1 : numTrain
    % Discretize the states
    [centroids(:, :, i), N] = get_centroids(trainData{i}.data, N, D);
    ATrain{i}               = get_clusters(trainData{i}.data, centroids(:, :, i), D);

    % Set priors:
    [~, priorE] = set_prior(M, N, LR);
    priorP = diag([ones(M - 1, 1) * 0.9; 1]) + diag(ones(M - 1, 1) * 0.1, 1);
    
    % Train the model:
%     [E(:, :, i), P(:, :, i), Pi(:, :, i), LL{i}] = hmm_train(ATrain{i}, priorP, 1:N, M, cycle, thresh);
     [P(:, :, i), E(:, :, i)] = hmmtrain(ATrain{i}, priorP, priorE', 'Verbose', true, 'MaxIter', 100);
end

%% Testing
if ~test
   return; 
end

% Initialize
testFile = fullfile(scriptDir, '../data', 'test_data.mat');
testData = load_data(testDir, testFile, 'test');
numTest  = numel(testData);
ATest    = cell(numTest, 1);

% Predict the right class with the highest recognition precision
class      = 'Not Found';
for j = 1 : numTest
    percentage = -Inf;
    for i = 1 : numTrain
        ATest{j} = get_clusters(testData{j}.data, centroids(:, :, i), D);
%         tmp      = find_gesture(E(:, :, i), P(:, :, i), Pi(:, :, i), ATest{j}, ATrain{i}, trainData{i}.name);
        [~, tmp] = hmmdecode(cell2mat(ATest{j}), P(:, :, i), E(:, :, i));
        if isnan(tmp)
            tmp = -Inf;
        end
        if verbose
            sprintf('Log Likelihood is %f', tmp);
        end
        if tmp > percentage
            percentage = tmp;
            class = trainData{i}.name;
        end
    end
    fprintf('\n Test Data %s is found to be %s\n', testData{j}.name, class);
end