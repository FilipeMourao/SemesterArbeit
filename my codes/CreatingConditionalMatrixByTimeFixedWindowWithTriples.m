function [conditionalMatrixPP,conditionalMatrixNP,conditionalMatrixPN,conditionalMatrixNN,independentProbabilities,idMaps,occurencesMatrix,mapTriples]= ...
CreatingConditionalMatrixByTimeFixedWindowWithTriples(T,minimumTimeSeconds, maximumTimeMinutes,timeIntervalMinutes,minimumAlarmOcurrences)

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
[TSortedByTime,idMaps] =  removingUnecessaryData(T,minimumTimeSeconds, maximumTimeMinutes,minimumAlarmOcurrences);

%Pre allocation of memory
uniqueID = idMaps(:,1);
numberOfDifferentIds = length(uniqueID);
occurencesMatrix = zeros(numberOfDifferentIds);
conditionalMatrixPP= zeros(numberOfDifferentIds);
conditionalMatrixNP= zeros(numberOfDifferentIds);
conditionalMatrixPN= zeros(numberOfDifferentIds);
conditionalMatrixNN= zeros(numberOfDifferentIds);
mapTriples= creatingTriplesMap(numberOfDifferentIds);
%% Compute occurence matrix
iDColum = TSortedByTime.('UniqueIDs');
starrtingTime = TSortedByTime.('starttime');

lastRow = 1;
while(lastRow < length(iDColum))
    length(iDColum)
    lastRow
    firstRow = lastRow + 1;
    timeTest = (datenum(starrtingTime(lastRow)) - datenum(starrtingTime(firstRow)))*24*60;
    while(timeTest < timeIntervalMinutes)
        lastRow = lastRow + 1;
        timeTest = (datenum(starrtingTime(lastRow)) - datenum(starrtingTime(firstRow)))*24*60;
    end
    % Counting with the limitant of an alarm ABCCABCBC 
%|2 2 2|
%|2 3 3|
%|2 3 4|

    %Condider just the group alarm, which alarms appear in this group
    alarmsAppearingInTheInterval = iDColum(firstRow:lastRow);%taking the alarms that appear in the windowed time
    uniqueIDInterval=unique(alarmsAppearingInTheInterval);%taking just the unique alarms that appear in the windowed time
    uniqueIDIntervalOccurences=unique(alarmsAppearingInTheInterval); %mapping the unique alarm that appear in the windowed time
    for i = 1:length(uniqueIDInterval)
     countingArray = alarmsAppearingInTheInterval == uniqueIDInterval(i);%count the occurences of the unique alarm i in the interval
     uniqueIDIntervalOccurences(i) = sum(countingArray);   %update the mapping array with the alarm data
    end
    for i = 1:length(uniqueIDInterval)
        occurencesMatrix(uniqueIDInterval(i),uniqueIDInterval(i)) = ...
            occurencesMatrix(uniqueIDInterval(i),uniqueIDInterval(i))  + uniqueIDIntervalOccurences(i) ;
        for j = i+1:length(uniqueIDInterval)
            occurencesMatrix(uniqueIDInterval(i),uniqueIDInterval(j)) = ...
                occurencesMatrix(uniqueIDInterval(i),uniqueIDInterval(j))  + min(uniqueIDIntervalOccurences(i),uniqueIDIntervalOccurences(j)) ;
            occurencesMatrix(uniqueIDInterval(j),uniqueIDInterval(i)) = ...
                occurencesMatrix(uniqueIDInterval(j),uniqueIDInterval(i))  + min(uniqueIDIntervalOccurences(i),uniqueIDIntervalOccurences(j)) ;
            %updatig the triple matrix 
            for k = j+1:length(uniqueIDInterval)
                uniqueString = mappingNumbersIntoString(uniqueIDInterval(i),uniqueIDInterval(j),uniqueIDInterval(k));
                mapTriples(uniqueString) = min(min(uniqueIDIntervalOccurences(i),uniqueIDIntervalOccurences(j)),uniqueIDIntervalOccurences(k));    
            end
        end
        
    end

end
%% Compute conditional probability  matrixes

totalNumberOfAlarms = 0;
for i = 1:size(occurencesMatrix,1)
    totalNumberOfAlarms = totalNumberOfAlarms + occurencesMatrix(i,i);  
end
independentProbabilities = zeros(size(occurencesMatrix,1),2);
% independentProbabilities = sum(occurencesMatrix,1);
% independentProbabilities = independentProbabilities/sum(independentProbabilities);
for i = 1:size(occurencesMatrix,1)
    independentProbabilities(i,1) = occurencesMatrix(i,i)/totalNumberOfAlarms;
    independentProbabilities(i,2) = occurencesMatrix(i,i);
end


for i = 1:size(occurencesMatrix,1)
    %There are many alarms that just appear a limitable number of times 
    for j = 1:length(conditionalMatrixPP)
    %%Computing Postive/Posite Matrix
        % P(B|A) = P(B&&A)/P(A)
        % numberOfOccurences(A,B)/numberOfOccurences(A)
        conditionalMatrixPP(i,j)= ( occurencesMatrix(i,j))/(occurencesMatrix(j,j));
        
        %%Computing Postive/Negative Matrix
        % P(B|~A) = P(B&&~A)/P(~A)
        %(numberOfOccurences(B) - numberOfOccurences(A,B))/(numberOfTotalAlarmsOccurences - numberOfOccurences(A))
        conditionalMatrixPN(i,j) = (occurencesMatrix(i,i) - occurencesMatrix(i,j))/(totalNumberOfAlarms - occurencesMatrix(j,j));
        
        %%Computing Negative/Postive Matrix
        % P(~B|A) = P(~B&&A)/P(A)
        %(numberOfOccurences(A)  - numberOfOccurences(A,B))/(numberOfOccurences(A))
        conditionalMatrixNP(i,j) = (occurencesMatrix(j,j)  - occurencesMatrix(i,j) )/(occurencesMatrix(j,j));
        %%Computing Negative/Negative Matrix
        % P(~B|~A) = P(~B&&~A)/P(~A)
        %   (numberOfTotalAlarmsOccurences + numberOfOccurences(A,B)   - numberOfOccurences(A) - numberOfOccurences(B))/(numberOfTotalAlarmsOccurences - numberOfOccurences(A))
         conditionalMatrixNN(i,j) = (totalNumberOfAlarms  + occurencesMatrix(i,j) - occurencesMatrix(i,i) - occurencesMatrix(j,j) )...
        /(totalNumberOfAlarms   - occurencesMatrix(j,j));
    end
end
end
%maps the 3 nubmers into a string, it's easy to map triples in this way and
%it takes less memory
function [numberString] = mappingNumbersIntoString(firstNumber,sencodNumber,thirdNumber)
    numberArray = [firstNumber,sencodNumber,thirdNumber];
    smallestNumber = min(numberArray);
    medianNumber = median(numberArray); 
    biggestNumer = max(numberArray);
    numberString = string(smallestNumber )+"-" + string(medianNumber)+ "-"+ string(biggestNumer);
    numberString = convertStringsToChars(numberString);
end
function [mapTriples] = creatingTriplesMap(numberOfDifferentIds)
    mapTriples = containers.Map;
    for i=1:numberOfDifferentIds
        for j = i+1:numberOfDifferentIds
            for k = j+1:numberOfDifferentIds
                string = mappingNumbersIntoString(i,j,k);
                mapTriples(string) = 0;
            end
        end
    end
end

