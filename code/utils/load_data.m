function trainData = load_data(dataDir, trainDir)
% LOAD_DATA() initially loads the data
% Written by Qiong Wang at University of Pennsylvania
% 02/28/2014

if ~exist('trainData', 'file')
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
    save(trainDir, 'trainData');
else
    load(trainDir);
end