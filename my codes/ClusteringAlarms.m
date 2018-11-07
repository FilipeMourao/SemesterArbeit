function [clusterAlarms] = ClusteringAlarms (relatedAlarms)
    %Pre allocation of memory
    clusterAlarms = [];
    alarmGroup = [];
    
    for i=1:size(relatedAlarms,1)
        if (~isempty(alarmGroup))
            groupLength = 1;
            totalGroupSize = length(alarmGroup);
            while(groupLength <= totalGroupSize) 
                alarmNumber = alarmGroup(groupLength);
                currentlyArray = relatedAlarms(alarmNumber,:);%Remove zeros from row
                %currentlyArray = calculatedProbabilitiesPP(alarmNumber,:);
                currentlyArray = currentlyArray(currentlyArray~=0); 
                for k = currentlyArray%%add the elements that the alarmNumber depends     
                    if(~max(ismember(alarmGroup,k)) )
                    %if(~max(ismember(alarmGroup,k))  && ~max(max(ismember(clusterAlarms,k))) )%nao achou
                        alarmGroup = [alarmGroup,k];
                        totalGroupSize = totalGroupSize + 1;
                    end
                end
                for j = 1:size(relatedAlarms,1)%add the elements that depend of the alarmNumber
                currentlyArray = relatedAlarms(j,:);%Remove zeros from row
                %currentlyArray = calculatedProbabilitiesPP(j,:);
                    if(max(ismember(currentlyArray,alarmNumber)))
                         if(~max(ismember(alarmGroup,j)) )%nao achou
                        %if(~max(ismember(alarmGroup,k))  && ~max(max(ismember(clusterAlarms,k))) )%nao achou
                            alarmGroup = [alarmGroup,j];
                            totalGroupSize = totalGroupSize + 1;
                        end
                    end
                end
                
                groupLength = groupLength + 1;
            end
            completeArray = zeros(1,size(relatedAlarms,1));
            completeArray(1:length(alarmGroup)) = alarmGroup;
            clusterAlarms = [clusterAlarms;completeArray];
            alarmGroup = [];
        end
        if (isempty( alarmGroup) )
            if (isempty(clusterAlarms) || ~max(max(ismember(clusterAlarms,i))) )
                 alarmGroup = [alarmGroup,i];
            end
        end 
    end
end