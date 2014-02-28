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
if ~exist('train_data', 'file')
    dirGest    = dir(dataDir);
    isDir      = [dirGest(:).isdir];
    dirName    = {dirGest(isDir).name}';
    dirName(ismember(dirName, {'.','..'})) = [];
    numGest    = length(dirName);
    trainData  = cell(numGest, 1);
    
    for gestIdx = 1 : numGest
        gestStr    = fullfile(dataDir, char(dirName(gestIdx)));
        dirData    = dir(gestStr);
        dataName   = {dirData(:).name}';
        dataName(ismember(dataName, {'.','..'})) = [];
        numData    = length(dataName);
        trainData{gestIdx}.class = gestIdx;
        trainData{gestIdx}.name  = dirName(gestIdx);
        
        for dataIdx = 1 : numData
            dataStr = char(dataName(dataIdx));
            tmp = load(fullfile(gestStr, dataStr));
            trainData{gestIdx}.data{dataIdx}.imu = tmp(:, 2 : 7)';
            trainData{gestIdx}.data{dataIdx}.t   = tmp(:, 1)' - tmp(1, 1);
        end
    end
    save(fullfile(dataDir, 'train_data.mat'), 'trainData');
else
    load(fullfile(dataDir, 'train_data.mat'));
end

%% Train Hidden Marcov Model
% Filter the data


% Generative HMM model

%