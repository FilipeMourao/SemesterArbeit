function [conditionalMatrixPP,conditionalMatrixNP,conditionalMatrixPN,conditionalMatrixNN,independentProbabilities,idMaps] = creatingConditionalMatrix(T,minimumTime, maximumTime,numberOfPreviousAlarmConsidered)

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
if  isempty(minimumTime)
    minimumTime = 10;
end
if  isempty(maximumTime)
    maximumTime = 10;
end
if  isempty(numberOfPreviousAlarmConsidered)
    numberOfPreviousAlarmConsidered = 1;
end
%% Pre processing 
%exclude all unecessary and incomplete values of the data set
[TSortedByTime,idMaps] =  removingUnecessaryData(T,minimumTime, maximumTime);

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
for i=1:length(iDColum)% go through the id colum in the table
    for j=1:numberOfPreviousAlarmConsidered% number of next alarm 
        if( (i + j < length(iDColum)) &&(iDColum(i) ~= iDColum(i + j) )  )% if we are not at the end of the colum, keep increasing the matrix
            occurencesMatrix(iDColum(i),iDColum(i)) = occurencesMatrix(iDColum(i),iDColum(i)) + 1;
            occurencesMatrix(iDColum(i + j),iDColum(i)) = occurencesMatrix(iDColum(i + j),iDColum(i)) + 1;            
        end
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

