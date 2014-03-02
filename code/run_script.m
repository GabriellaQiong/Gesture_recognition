% Run Script for Project 3 Gesture Recognition, ESE 650
% Written by Qiong Wang at University of Pennsylvania
% 02/26/2014

%% Clear up
clearvars -except trainData;
close all;
clc;

%% Flags
check   = false;                     % Whether to do sanity check
verbose = false;                     % Whether to show the details
test    = false;                     % Whether to test

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
trainData = load_data(trainDir, trainFile);

%% Parameters
D         = 6;                         % Number of dimensions to use: X, Y, Z
M         = numel(trainData);          % Number of output symbols
N         = 5;                         % Number of states
LR        = 4;                         % Degree of play in the left-to-right HMM transition matrix 
cycle     = 100;
thresh    = 1e-6;

%% Train Hidden Marcov Model
% Initialize
centroids = zeros(N, D, M);
E         = zeros(N, M, M);
P         = zeros(M, M, M);
Pi        = zeros(1, M, M);
ATrain    = cell(M, 1);
% LL        = zeros(1, d, M);

for i = 1 : M
    % Discretize the states
    [centroids(:, :, i), N] = get_centroids(trainData{i}.data, N, D);
    ATrain{i}               = get_clusters(trainData{i}.data, centroids(:, :, i));

    % Set priors:
    prior = set_prior(M, LR);
    
    % Train the model:
    [E(:, :, i), P(:, :, i), Pi(:, :, i), LL] = hmm_train(ATrain{i}, prior, 1:N, M, cycle, thresh);
end

%% Testing
ATest = get_clusters(testData, centroids);
