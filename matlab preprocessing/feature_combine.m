function [nbrBeats combinedFtCell] = feature_combine(filename)
% Purpose:
% load a '.mat' file, extract its 'feature', and combine it
%
% Inputs:
% 'filename' is the name of the file supposed to  be open
%
% featureName is the name of the feature supposed to  be extract
%
% Outputs:
% 'nbrBeats' the number of heartbeats
%
% 'combinedFeature' is the combined feature
%
% Example:
% please see the file 'pre_main.m'
load (filename);

nbrBeats = length(indexS);

fit3FtORG = fit3FtORGcell{1}; %fit3FtORGcell{1} is a mat whose dimension is nbrBeats x 9
fit3FtSL = fit3FtSLcell{1};
fit3FtSLH = fit3FtSLHcell{1};


for i = 2:13
    fit3FtORG = cat(2, fit3FtORG, fit3FtORGcell{i});
    fit3FtSL = cat(2, fit3FtSL, fit3FtSLcell{i});
    fit3FtSLH = cat(2, fit3FtSLH, fit3FtSLHcell{i});
       
end

combinedFtCell{1, 1} = fit3FtORG;
combinedFtCell{2, 1} = fit3FtSL;
combinedFtCell{3, 1} = fit3FtSLH;

