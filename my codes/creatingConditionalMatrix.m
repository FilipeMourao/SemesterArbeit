function [occurencesMatrix, conditionalMatrix] = creatingConditionalMatrix(T,nameOfIdColum ,numberOfPreviousAlarmConsidered)

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

%% Pre processing 
%exclude all the disactivation rows values
rowsToExclude = T(:,T.('NewStatus')) == 0;
TOnlyAcivationStatus = T;
TOnlyAcivationStatus(rowsToExclude,:) = [];

%sort for the time 
TSortedByTime = sortrows(TOnlyAcivationStatus,'date');

%Pre allocation of memory
iDColum = TSortedByTime.(nameOfIdColum);
uniqueID = unique(iDColum);
numberOfDifferentIds = length(uniqueID);
occurencesMatrix = zeros(numberOfDifferentIds);
conditionalMatrix= zeros(numberOfDifferentIds);

%% Compute occurence matrix
for i=1:length(iDColum)% go through the id colum in the table
    for j=1:numberOfPreviousAlarmConsidered% number of next alarm 
        if( i + j < length(iDColum) )% if we are not at the end of the colum, keep increasing the matrix
            occurencesMatrix(iDColum(i),iDColum(i)) = occurencesMatrix(iDColum(i),iDColum(i)) + 1;
            occurencesMatrix(iDColum(i),iDColum(i + j)) = occurencesMatrix(iDColum(i),iDColum(i + j)) + 1;
            
    
%% Compute conditional probability  matrix
for i = 1:size(occurencesMatrix,1)
    conditionalMatrix(i,:) = occurencesMatrix(i,:)/(occurencesMatrix(i,i));


