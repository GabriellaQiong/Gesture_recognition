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
train_data = struct;
dirData    = dir(dataDir);
isDir      = [dirData(:).isdir];
dirName    = {dirData(isDir).name}';
dirName(ismember(dirName,{'.','..'})) = [];
numGest    = length(dirName);

for gestIdx = 1 : numGest
    load_data(fullfile(dataDir, dirName(gestIdx)));
    train_data(i).class=i;
    train_data(i).name=nameC{i};
    train_data(i).accel=[accel_x'; accel_y'; accel_z'];
    train_data(i).gyro=[gyro_x'; gyro_y'; gyro_z'];
    train_data(i).imu=[train_data(i).accel; train_data(i).gyro];
end


dataIdx = input('Please choose one dataset: ');
load(fullfile(imuDir, ['imuRaw', num2str(dataIdx)]));
tsImu   = ts;
load(fullfile(viconDir, ['viconRot', num2str(dataIdx)]));
tsVicon = ts;
if dataIdx < 3 || dataIdx == 13
    load(fullfile(camDir, ['cam', num2str(dataIdx)]));
    tsCam   = ts;
end

%% Train Hidden Marcov Model