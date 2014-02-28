% Run Script for Project 3 Gesture Recognition, ESE 650
% Written by Qiong Wang at University of Pennsylvania
% 02/26/2014

%% Clear up
clear all;
close all;
clc;

%% Initialize
check   = false;                     % Whether to do sanity check
verbose = false;                     % Whether to show the details
test    = false;                     % Whether to test

%% Path
scriptDir = fileparts(mfilename('fullpath'));
dataDir   = '/home/qiong/ese650_data/project3/train';
outputDir = fullfile(scriptDir, '../results');
if ~exist(outputDir, 'dir')
    mkdir(outputDir); 
end
addpath(genpath('../code'));

%% Load data
trainDir  = fullfile(scriptDir, '../data', 'train_data.mat');
trainData = load_data(dataDir, trainDir);

%% Train Hidden Marcov Model
% Filter the data
trainData = fft_filter(trainData);

% Generative HMM model

%