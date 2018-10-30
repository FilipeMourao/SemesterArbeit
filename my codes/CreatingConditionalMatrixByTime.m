function [conditionalMatrixPP,conditionalMatrixNP,conditionalMatrixPN,conditionalMatrixNN,independentProbabilities,idMaps,occurencesMatrix]= ...
CreatingConditionalMatrixByTime(T,minimumTimeSeconds, maximumTimeMinutes,timeIntervalMinutes)

%% Create conditional matrix of alarms 
% Input
% Table T 
%Int numberOfPreviousAlarmConsidered: how many alarms should be considered in a sequnce 
%ex : if  numberOfPreviousAlarmConsidered = 1  in the sequence ABC we are
%just counting the combination AB and AC, if
%numberOfPreviousAlarmConsidered = 2 we will also count AC
%String nameOfIdColum: name of the id colum in the table 
%
% Output
% occurencesMatrix: Matrix with the occurences between 2 alarms
%conditionalMatrix: Matrix containing the conditional probabilities between
%alarms
if  isempty(minimumTimeSeconds)
    minimumTimeSeconds = 10;
end
if  isempty(maximumTimeMinutes)
    maximumTimeMinutes = 10;
end
if  isempty(timeIntervalMinutes)
    timeIntervalMinutes = 5;
end
%% Pre processing 
%exclude all unecessary and incomplete values of the data set
[TSortedByTime,idMaps] =  removingUnecessaryData(T,minimumTimeSeconds, maximumTimeMinutes);

%Pre allocation of memory
uniqueID = idMaps(:,1);
numberOfDifferentIds = length(uniqueID);
occurencesMatrix = zeros(numberOfDifferentIds);
conditionalMatrixPP= zeros(numberOfDifferentIds);
conditionalMatrixNP= zeros(numberOfDifferentIds);
conditionalMatrixPN= zeros(numberOfDifferentIds);
conditionalMatrixNN= zeros(numberOfDifferentIds);


%% Compute occurence matrix
iDColum = TSortedByTime.('UniqueIDs');
starrtingTime = TSortedByTime.('starttime');
for i=1:length(iDColum) - 1% go through the id colum in the table
    length(iDColum)
    i
    j = i + 1;
    timeTest = (datenum(starrtingTime(j)) - datenum(starrtingTime(i)))*24*60;
    occurencesMatrix(iDColum(i),iDColum(i)) = occurencesMatrix(iDColum(i),iDColum(i)) + 1;
    while( (j < length(iDColum) )&& ... 
        (iDColum(i) ~= iDColum(j)) && ...
            timeTest < timeIntervalMinutes )
        if(j > i + 1)
             occurencesMatrix(iDColum(i),iDColum(i)) = occurencesMatrix(iDColum(i),iDColum(i)) + 1;
        end
            occurencesMatrix(iDColum(j),iDColum(i)) = occurencesMatrix(iDColum(j),iDColum(i)) + 1;
            timeTest = (datenum(starrtingTime(j)) - datenum(starrtingTime(i)))*24*60;
            j = j + 1;
    end
end
%% Compute conditional probability  matrixes
for i = 1:size(occurencesMatrix,1)
    conditionalMatrixPP(:,i) = occurencesMatrix(:,i)/(occurencesMatrix(i,i));
end
independentProbabilities = sum(occurencesMatrix,1);
independentProbabilities = independentProbabilities/sum(independentProbabilities);

for i = 1:length(conditionalMatrixPP)
    for j = 1:length(conditionalMatrixPP)
        conditionalMatrixPN(i,j) = (independentProbabilities(i) - ...
         conditionalMatrixPP(i,j)*independentProbabilities(j))...
     /(1 - independentProbabilities(j));
    end
end
for i = 1:length(conditionalMatrixPP)
    for j = 1:length(conditionalMatrixPP)
        conditionalMatrixPN(i,j) = (independentProbabilities(i) - ...
         conditionalMatrixPP(i,j)*independentProbabilities(j))...
     /(1 - independentProbabilities(j));
    end
end
conditionalMatrixNP(:,:) = 1 - conditionalMatrixPP(:,:); 
conditionalMatrixNN(:,:) = 1 - conditionalMatrixPN(:,:); 
end

