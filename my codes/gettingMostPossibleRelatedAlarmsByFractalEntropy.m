function [relatedAlarmsFractalEntropy,calculatedProbabilitiesFractalEntropy] = ...
    gettingMostPossibleRelatedAlarmsByFractalEntropy ...
( conditionalFractalEntropyMatrix,minimumFractalEntropyValue)


%Pre allocation of memory
relatedAlarmsFractalEntropy = zeros(size(conditionalFractalEntropyMatrix,1),size(conditionalFractalEntropyMatrix,1));

calculatedProbabilitiesFractalEntropy = zeros(size(conditionalFractalEntropyMatrix,1),size(conditionalFractalEntropyMatrix,1));
for i=1:size(conditionalFractalEntropyMatrix,1)
    alarms =[];
    alarmsFractalEntropies =[];
    for j = 1:size(conditionalFractalEntropyMatrix,1)
        if  conditionalFractalEntropyMatrix(i,j) > minimumFractalEntropyValue
            alarms  = [alarms,conditionalFractalEntropyMatrix(i,j)];
            alarmsFractalEntropies =[alarmsFractalEntropies,j];
        end
    end
    
    vec = zeros(size(conditionalFractalEntropyMatrix,1),1);
    vec( 1:length(alarms) ) = alarms;
    calculatedProbabilitiesFractalEntropy (i,:) = vec;
    
    vec = zeros(size(conditionalFractalEntropyMatrix,1),1);
    vec( 1:length(alarmsFractalEntropies) ) = alarmsFractalEntropies;
    relatedAlarmsFractalEntropy(i,:) = vec;
    
end
end