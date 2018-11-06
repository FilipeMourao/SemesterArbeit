function [relatedAlarmsPP,relatedAlarmsNP,relatedAlarmsPN,relatedAlarmsNN ...
    ,calculatedProbabilitiesPP, calculatedProbabilitiesPN ... 
    ,calculatedProbabilitiesNP, calculatedProbabilitiesNN] = ...
    gettingMostPossibleRelatedAlarmsByProbabilty ...
(conditionalMatrixPP,conditionalMatrixNP,conditionalMatrixPN ...
,conditionalMatrixNN,minimumProbability)


%Pre allocation of memory
relatedAlarmsPP = zeros(size(conditionalMatrixPP,1),size(conditionalMatrixPP,1));
relatedAlarmsPN = zeros(size(conditionalMatrixPP,1),size(conditionalMatrixPP,1));
relatedAlarmsNP = zeros(size(conditionalMatrixPP,1),size(conditionalMatrixPP,1));
relatedAlarmsNN = zeros(size(conditionalMatrixPP,1),size(conditionalMatrixPP,1));
calculatedProbabilitiesPP = zeros(size(conditionalMatrixPP,1),size(conditionalMatrixPP,1));
calculatedProbabilitiesPN = zeros(size(conditionalMatrixPP,1),size(conditionalMatrixPP,1));
calculatedProbabilitiesNP = zeros(size(conditionalMatrixPP,1),size(conditionalMatrixPP,1));
calculatedProbabilitiesNN = zeros(size(conditionalMatrixPP,1),size(conditionalMatrixPP,1));
for i=1:size(conditionalMatrixPP,1)
    conditionalMatrixPP(i,i) = -999;
    conditionalMatrixPN(i,i) = -999;
    conditionalMatrixNP(i,i) = -999;
    conditionalMatrixNN(i,i) = -999;
    alarmsPP =[];
    alarmsPN =[];
    alarmsNP =[];
    alarmsNN =[];
    alarmsProbabilitiesPP =[];
    alarmsProbabilitiesPN =[];
    alarmsProbabilitiesNP =[];
    alarmsProbabilitiesNN =[];
    for j = 1:size(conditionalMatrixPP,1)
        if  conditionalMatrixPP(i,j) > minimumProbability
            alarmsPP  = [alarmsPP,conditionalMatrixPP(i,j)];
            alarmsProbabilitiesPP =[alarmsProbabilitiesPP,j];
        end
        if  conditionalMatrixPN(i,j) > minimumProbability
            alarmsPN  = [alarmsPN,conditionalMatrixPN(i,j)];
            alarmsProbabilitiesPN =[alarmsProbabilitiesPN,j];
        end
        if  conditionalMatrixNP(i,j) > minimumProbability
            alarmsNP = [alarmsNP,conditionalMatrixNP(i,j)];
            alarmsProbabilitiesNP =[alarmsProbabilitiesNP,j];
        end
        if  conditionalMatrixNN(i,j) > minimumProbability
            alarmsNN = [alarmsNN,conditionalMatrixNN(i,j)];
            alarmsProbabilitiesNN =[alarmsProbabilitiesNN,j];
        end
      
    end
    
    vec = zeros(size(conditionalMatrixPP,1),1);
    vec( 1:length(alarmsPP) ) = alarmsPP;
    calculatedProbabilitiesPP (i,:) = vec;
    
    vec = zeros(size(conditionalMatrixPP,1),1);
    vec( 1:length(alarmsProbabilitiesPP) ) = alarmsProbabilitiesPP;
    relatedAlarmsPP(i,:) = vec;
    
    vec = zeros(size(conditionalMatrixPP,1),1);
    vec( 1:length(alarmsPN) ) = alarmsPN;
    calculatedProbabilitiesPN (i,:) = vec;
    
    vec = zeros(size(conditionalMatrixPP,1),1);
    vec( 1:length(alarmsProbabilitiesPN) ) = alarmsProbabilitiesPN;
    relatedAlarmsPN(i,:) = vec;
    
    vec = zeros(size(conditionalMatrixNP,1),1);
    vec( 1:length(alarmsProbabilitiesNP) ) = alarmsProbabilitiesNP;
    relatedAlarmsNP(i,:) = vec;
    
    vec = zeros(size(conditionalMatrixPP,1),1);
    vec( 1:length(alarmsNP) ) = alarmsNP;
    calculatedProbabilitiesNP (i,:) = vec;
    
    
    vec = zeros(size(conditionalMatrixPP,1),1);
    vec( 1:length(alarmsProbabilitiesNN) ) = alarmsProbabilitiesNN;
    relatedAlarmsNN(i,:) = vec;
    
    vec = zeros(size(conditionalMatrixPP,1),1);
    vec( 1:length(alarmsNN) ) = alarmsNN;
    calculatedProbabilitiesNN (i,:) = vec;
end
end