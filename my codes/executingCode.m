%% defining constant variables
load('table.mat');
maximumTimeMinutes = 10; 
minimumTimeSeconds = 10;
minimumAlarmOcurrences = 20;
timeIntervalMinutes = 10;
minimumProbability = 0.7;
minimumFractalEntropyValue = 10e-2;

%% Getting conditional Matrix
[conditionalMatrixPP,conditionalMatrixNP,conditionalMatrixPN,conditionalMatrixNN,independentProbabilities,idMaps,occurencesMatrix]...
= CreatingConditionalMatrixByTimeFixedWindow(T,minimumTimeSeconds, maximumTimeMinutes,timeIntervalMinutes,minimumAlarmOcurrences);
% [conditionalMatrixPP,conditionalMatrixNP,conditionalMatrixPN,conditionalMatrixNN,independentProbabilities,idMaps,occurencesMatrix]...
% = CreatingConditionalMatrixByTime(T,minimumTimeSeconds, maximumTimeMinutes,timeIntervalMinutes,minimumAlarmOcurrences);
%LoadConditionalMatrixes
% load('conditionalMatrixByTime/20_minutes/conditionalMatrixPP.mat');
% load('conditionalMatrixByTime/20_minutes/conditionalMatrixPN.mat');
% load('conditionalMatrixByTime/20_minutes/conditionalMatrixNP.mat');
% load('conditionalMatrixByTime/20_minutes/conditionalMatrixNN.mat');
% load('conditionalMatrixByTime/20_minutes/independentProbabilities.mat');
% load('conditionalMatrixByTime/20_minutes/idMaps.mat');
S = "Conditional Matrixes calculated!"
%% Calculating fractal entropy
[ transferEntropyMatrix] = ...
calculatingTransferEntropyByTime(conditionalMatrixPP,conditionalMatrixNP,conditionalMatrixPN,conditionalMatrixNN,independentProbabilities);
S = "Fractal Matrix calculated!"

%% Clustering the elements by conditional probabilities
[relatedAlarmsPP] = ...
    gettingMostPossibleRelatedAlarmsByProbabilty ...
(conditionalMatrixPP,conditionalMatrixNP,conditionalMatrixPN ...
,conditionalMatrixNN,minimumProbability);
[clusterAlarmsConditionalProbability] = ClusteringAlarms (relatedAlarmsPP);
S = "Cluster alarms for probability!"

%% Clustering the elements by fractal entropy
[relatedAlarmsTrasnferEntropy] = gettingMostPossibleRelatedAlarmsByFractalEntropy ...
(transferEntropyMatrix, minimumFractalEntropyValue);
[clusterAlarmsTransferEntropy] = ClusteringAlarms (relatedAlarmsTrasnferEntropy);
S = "Cluster alarms for fractal entropy!"
