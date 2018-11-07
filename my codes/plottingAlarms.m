function  plottingAlarms(T)
    oID = 'FehlerID';%string, name of old ID column (e.g. alarm name or description)
    nID = 'UniqueIDs';%string, name of new ID column (unique number for every unique old ID)
    rowsToExclude = T.(oID) == 1;
    T(rowsToExclude,:) = []; 
    %% Assign unique number to every unique ID
    uniqueID=unique(T.(oID));
    ID=zeros(height(T),1);
    IDMap=cell(length(uniqueID),2);
    if isnumeric(uniqueID)
        for i=1:length(uniqueID)
            ID(T.(oID)==uniqueID(i))=i;
            IDMap{i,1}=i;
            IDMap{i,2}=uniqueID(i);
        end
    else
        for i=1:length(uniqueID)
            ID(strcmp(T.(oID),uniqueID{i}))=i;
            IDMap{i,1}=i;
            IDMap{i,2}=uniqueID{i};
        end
    end
    T.(nID)=ID;
    tSorted = sortrows(T,  find(strcmpi(T.Properties.VariableNames,'starttime')) ); 
    tSorted(:,oID) = [];
    
    
    %%Starting the plots  
    convertedAlarms = cell2mat(IDMap(:,1));
    for number = 1:size(convertedAlarms) 
        numberOfAlarm = convertedAlarms(number);
        timeCalculation = [];
        startTimeArray = [];
        endTimeArray = [];
        %calculating plotting array
        for i = 1:size(tSorted,1)
            if(tSorted.(nID)(i) == numberOfAlarm)
                timeResult = ( datenum(tSorted.('endtime')(i)) - datenum(tSorted.('starttime')(i)) )*24*3600;
                startTimeArray = [startTimeArray,datenum(tSorted.('starttime')(i))/12];
                endTimeArray = [endTimeArray,datenum(tSorted.('endtime')(i))/12];
                timeCalculation = [timeCalculation,timeResult];
            end
        end
      % endTimeArray(:) = endTimeArray(:)/10e7;
      %  startTimeArray(:) = startTimeArray(:)/10e7;
     
%         %Plot type 1
%         plottingArrayX = 1:length(timeCalculation);
%         scatter(plottingArrayX,timeCalculation);
%         value = IDMap(number,2);
%         title(join(['Time between StartTime and EndTime of alarm ', num2str(value{1})]));
%         %title('Time between StartTime and EndTime of alarm ');
%         xlabel('Number of times this alarm was triggered');
%         ylabel('Difference in seconds');
%         hold on
%         timeMean = mean(timeCalculation);
%         meanArray = ones(length(timeCalculation),1)*timeMean; 
%         plot(plottingArrayX,meanArray,'LineWidth',3);
%         legend('Value per occurance',join(['mean = ', num2str(timeMean),' seconds']))
%         hold off
         
%         %Plot type 2
%         currentSum = 0;
%         plottingArray = zeros(length(timeCalculation),1);
%         for i = 1:length(timeCalculation)
%             plottingArray(i) = timeCalculation(i) + currentSum;
%             currentSum = currentSum + timeCalculation(i);
%         end
%         value = IDMap(number,2);
%         title(join(['Time between StartTime and EndTime of alarm ', num2str(value{1})]));
%         %title('Time  EndTime of alarm ');
%         xlabel('time(s)');
%         ylabel('Difference in seconds');
%         hold on; 
%         for idx = 1 : length(plottingArray)
%             plot([plottingArray(idx) plottingArray(idx)], [0 0.5],'Color','b');
%         end
%         axis([0 inf 0 1])
%         hold off
        
        %Plot type 3
        currentSum = 0;
        plottingArray = zeros(length(timeCalculation) + 1,1);
        for i = 1:length(timeCalculation)
            plottingArray(i + 1) = timeCalculation(i) + currentSum;
            currentSum = currentSum + timeCalculation(i);
        end
        value = IDMap(number,2);
        title(join(['Time between StartTime and EndTime of alarm ', num2str(value{1})]));
%         xlabel('time');
%         ylabel('Difference in seconds');
        hold on; 
        for idx = 1 : length(endTimeArray) - 1
            plot([plottingArray(idx) + 10, plottingArray(idx) + 10], [0 1],'Color','b','LineWidth',2);
            plot([plottingArray(idx + 1), plottingArray(idx + 1)], [0 1],'Color','r','LineWidth',2);
            plot([plottingArray(idx) + 10, plottingArray(idx + 1)], [1 1],'Color','k','LineWidth',1);
            duration = sprintf('%.2f',timeCalculation(idx)) ; 
            txt = join([duration,' s']);
            text(plottingArray(idx) + 10,1.02,txt,'FontSize',8);
        end
        axis([0 plottingArray(length(plottingArray)) + 10 0 2])
        legend('Alarm start','Alarm end')
        hold off
%         
%                 %Plot type 4
%        endTimeArray(:) = endTimeArray(:) - min(startTimeArray);
%        startTimeArray(:) = startTimeArray(:) - min(startTimeArray);
%         value = IDMap(number,2);
%         title(join(['Time between StartTime and EndTime of alarm ', num2str(value{1})]));
%         %title('Time between StartTime and EndTime of alarm ');
%         xlabel('time');
%         ylabel('Difference in seconds');
%         hold on; 
%         for idx = 1 : length(endTimeArray)
%             plot([startTimeArray(idx) startTimeArray(idx)], [0 0.5],'Color','b');
%             plot([endTimeArray(idx) endTimeArray(idx)], [0 0.5],'Color','r');
%         end
%         axis([0 inf 0 1])
%         hold off
%      
     
        break;
    end
end
