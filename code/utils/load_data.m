function trainData = load_data(dataDir,dataFile)
% LOAD_DATA() initially loads the data
% Written by Qiong Wang at University of Pennsylvania
% 02/28/2014

if ~exist(dataFile, 'file')
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
        trainData{gestIdx}.name  = char(dirName(gestIdx));
        
        for dataIdx = 1 : numData
            dataStr = char(dataName(dataIdx));
            tmp = load(fullfile(gestStr, dataStr));
            trainData{gestIdx}.data{dataIdx} = tmp(:, 2 : 7)';
        end
        
        lengArr = cell2mat(cellfun(@length, trainData{gestIdx}.data, 'UniformOutput', false));
        dataLeng = max(lengArr);
        
        trainData{gestIdx}.data = [];
        for dataIdx = 1 : numData
            dataStr = char(dataName(dataIdx));
            tmp = load(fullfile(gestStr, dataStr));
            for dimIdx = 1 : 6
                trainData{gestIdx}.data(:, dataIdx, dimIdx) = ...
                interp1(1 : length(tmp), tmp(:, dimIdx + 1), 1 : dataLeng, 'spline')';
            end
        end
        
    end
    save(dataFile, 'trainData');
elseif ~exist('trainData', 'var')
    load(dataFile);
end