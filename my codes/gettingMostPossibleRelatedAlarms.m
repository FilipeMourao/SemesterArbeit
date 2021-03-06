function [RelatedAlarmsPP,RelatedAlarmsNP,RelatedAlarmsPN,RelatedAlarmsNN ...
    ,CalculatedProbabilitiesPP, CalculatedProbabilitiesPN ... 
    ,CalculatedProbabilitiesNP, CalculatedProbabilitiesNN] = ...
    gettingMostPossibleRelatedAlarms ...
(conditionalMatrixPP,conditionalMatrixNP,conditionalMatrixPN ...
,conditionalMatrixNN,numberOfRelatedAlarms)


%Pre allocation of memory
RelatedAlarmsPP = zeros(size(conditionalMatrixPP,1),numberOfRelatedAlarms);
RelatedAlarmsPN = zeros(size(conditionalMatrixPP,1),numberOfRelatedAlarms);
RelatedAlarmsNP = zeros(size(conditionalMatrixPP,1),numberOfRelatedAlarms);
RelatedAlarmsNN = zeros(size(conditionalMatrixPP,1),numberOfRelatedAlarms);
CalculatedProbabilitiesPP = zeros(size(conditionalMatrixPP,1),numberOfRelatedAlarms);
CalculatedProbabilitiesPN = zeros(size(conditionalMatrixPP,1),numberOfRelatedAlarms);
CalculatedProbabilitiesNP = zeros(size(conditionalMatrixPP,1),numberOfRelatedAlarms);
CalculatedProbabilitiesNN = zeros(size(conditionalMatrixPP,1),numberOfRelatedAlarms);

for i=1:size(conditionalMatrixPP,1)
    conditionalMatrixPP(i,i) = -999;
    conditionalMatrixPN(i,i) = -999;
    conditionalMatrixNP(i,i) = -999;
    conditionalMatrixNN(i,i) = -999;

    for j=1:numberOfRelatedAlarms
        currentlyArray = conditionalMatrixPP(i,:);
        maxValue = max(currentlyArray);
        maxiPosition = find(currentlyArray == maxValue,1);
        RelatedAlarmsPP(i,j) = maxiPosition;
        CalculatedProbabilitiesPP(i,j) = conditionalMatrixPP(i,maxiPosition);
        conditionalMatrixPP(i,maxiPosition) = -999;
        
        currentlyArray = conditionalMatrixPN(i,:);
        maxValue = max(currentlyArray);
        maxiPosition = find(currentlyArray == maxValue,1);
        RelatedAlarmsPN(i,j) = maxiPosition;
        CalculatedProbabilitiesPN(i,j) = conditionalMatrixPN(i,maxiPosition);
        conditionalMatrixPN(i,maxiPosition) = -999;
        
        currentlyArray = conditionalMatrixNP(i,:);
        maxValue = max(currentlyArray);
        maxiPosition = find(currentlyArray == maxValue,1);
        RelatedAlarmsNP(i,j) = maxiPosition;
        CalculatedProbabilitiesNP(i,j) = conditionalMatrixNP(i,maxiPosition);
        conditionalMatrixNP(i,maxiPosition) = -999;
        
        currentlyArray = conditionalMatrixNN(i,:);
        maxValue = max(currentlyArray);
        maxiPosition = find(currentlyArray == maxValue,1);
        RelatedAlarmsNN(i,j) = maxiPosition;
        CalculatedProbabilitiesNN(i,j) = conditionalMatrixNN(i,maxiPosition);
        conditionalMatrixNN(i,maxiPosition) = -999;
    end
end



end