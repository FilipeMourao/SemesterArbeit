%% defining constant variables
load('table.mat');
maximumTimeMinutes = 10; 
minimumTimeSeconds = 10;
timeIntervalMinutes = 10;
minimumProbability = 0.1;
minimumFractalEntropyValue = 10e-5;

%% Getting conditional Matrix
% [conditionalMatrixPP,conditionalMatrixNP,conditionalMatrixPN,conditionalMatrixNN,independentProbabilities,idMaps]...
% = CreatingConditionalMatrixByTime(T,minimumTimeSeconds, maximumTimeMinutes,timeIntervalMinutes);
%LoadConditionalMatrixes
load('conditionalMatrixByTime/10_minutes/conditionalMatrixPP.mat');
load('conditionalMatrixByTime/10_minutes/conditionalMatrixPN.mat');
load('conditionalMatrixByTime/10_minutes/conditionalMatrixNP.mat');
load('conditionalMatrixByTime/10_minutes/conditionalMatrixNN.mat');
load('conditionalMatrixByTime/10_minutes/independentProbabilities.mat');
load('conditionalMatrixByTime/10_minutes/idMaps.mat');
S = "Conditional Matrixes calculated!"
%% Calculating fractal entropy
[independentFractalEntropyMatrix, conditionalFractalEntropyMatrix] = ...
calculatingFractalEntropyByTime(conditionalMatrixPP,conditionalMatrixNP,conditionalMatrixPN,conditionalMatrixNN,independentProbabilities);
S = "Fractal Matrix calculated!"

%% Clustering the elements by conditional probabilities
[relatedAlarmsPP] = ...
    gettingMostPossibleRelatedAlarmsByProbabilty ...
(conditionalMatrixPP,conditionalMatrixNP,conditionalMatrixPN ...
,conditionalMatrixNN,minimumProbability);
[clusterAlarmsConditionalProbability] = ClusteringAlarms (relatedAlarmsPP);
S = "Cluster alarms for probability!"

%% Clustering the elements by fractal entropy
[relatedAlarmsFractalEntropy] = gettingMostPossibleRelatedAlarmsByFractalEntropy ...
(conditionalFractalEntropyMatrix, minimumFractalEntropyValue);
[clusterAlarmsFractalEntropy] = ClusteringAlarms (relatedAlarmsFractalEntropy);
S = "Cluster alarms for fractal entropy!"
