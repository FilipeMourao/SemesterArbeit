function  plottingRelatedAlarms()
%     sizeOfthePointDifference = 100;
%     clusterAlarmsConditionalProbability_0_1 = cell2mat(struct2cell(load('relatedAlarmsByProbability/clusterAlarmsConditionalProbability_0.1.mat')));
%     clusterAlarmsConditionalProbability_0_2 = cell2mat(struct2cell(load('relatedAlarmsByProbability/clusterAlarmsConditionalProbability_0.2.mat')));
%     clusterAlarmsConditionalProbability_0_3 = cell2mat(struct2cell(load('relatedAlarmsByProbability/clusterAlarmsConditionalProbability_0.3.mat')));
%     clusterAlarmsConditionalProbability_0_4 = cell2mat(struct2cell(load('relatedAlarmsByProbability/clusterAlarmsConditionalProbability_0.4.mat')));
%     clusterAlarmsConditionalProbability_0_5 = cell2mat(struct2cell(load('relatedAlarmsByProbability/clusterAlarmsConditionalProbability_0.5.mat')));
%     coordinatesOfTheAlarms = zeros(size(clusterAlarmsConditionalProbability_0_4,2),2);
%     incrementOfOddNumber = 1;
%     constantFor
%     incrementOfEvenNumber = 1;
%     
%     clusterAlarms = clusterAlarmsConditionalProbability_0_4;
%     for i=1:size(clusterAlarms,1)
%         for j=1:nnz(clusterAlarms(i,:))
%             coordinatesOfTheAlarms(clusterAlarms(i,j),1) = sizeOfthePointDifference*(rand + incrementOfOddNumber);
%             coordinatesOfTheAlarms(clusterAlarms(i,j),2) = sizeOfthePointDifference*(rand + incrementOfEvenNumber);
%         end
%         y1=(incrementOfEvenNumber - 0.2)*sizeOfthePointDifference;    
%         y2=(1.2 + incrementOfEvenNumber)*sizeOfthePointDifference;
%         x1=(incrementOfOddNumber - 0.2)*sizeOfthePointDifference;    
%         x2=(1.2 + incrementOfOddNumber)*sizeOfthePointDifference;
%         x = [x1, x2, x2, x1, x1];
%         y = [y1, y1, y2, y2, y1];
%         plot(x, y, 'b-', 'LineWidth', 2);
%         set(gca,'xtick',[])
%         set(gca,'ytick',[])
%         hold on;
%         if(rem( i , 2 ) == 0)
%             incrementOfOddNumber = incrementOfOddNumber + 2; 
%         
%         else
%             incrementOfEvenNumber = incrementOfEvenNumber + 2;
%         end
% 
%     end
%         scatter(coordinatesOfTheAlarms(:,1),coordinatesOfTheAlarms(:,2));
%         value = IDMap(number,2);
%         title(join(['Time between StartTime and EndTime of alarm ', num2str(value{1})]));
%         %title('Time between StartTime and EndTime of alarm ');
% %         xlabel('Number of times this alarm was triggered');
% %         ylabel('Difference in seconds');
%         set(gca,'xtick',[])
%         set(gca,'ytick',[])
%         hold off 
%         
    sizeOfthePointDifference = 1;
    clusterAlarmsConditionalProbability_0_5 = cell2mat(struct2cell(load('relatedAlarmsByProbability/clusterAlarmsConditionalProbability_0.5.mat')));
    clusterAlarmsConditionalProbability_0_55 = cell2mat(struct2cell(load('relatedAlarmsByProbability/clusterAlarmsConditionalProbability_0.55.mat')));
    clusterAlarmsConditionalProbability_0_6 = cell2mat(struct2cell(load('relatedAlarmsByProbability/clusterAlarmsConditionalProbability_0.6.mat')));
    clusterAlarmsConditionalProbability_0_7 = cell2mat(struct2cell(load('relatedAlarmsByProbability/clusterAlarmsConditionalProbability_0.7.mat')));
    clusterAlarmsConditionalProbability_0_8 = cell2mat(struct2cell(load('relatedAlarmsByProbability/clusterAlarmsConditionalProbability_0.8.mat')));
    coordinatesOfTheAlarms = zeros(size(clusterAlarmsConditionalProbability_0_7,2),2);
    numberOfRows = ceil(sqrt(size(clusterAlarmsConditionalProbability_0_8,1)));
    positionMatrix = zeros(numberOfRows);
    mimimumNumberOfGroups = size(clusterAlarmsConditionalProbability_0_8,1);
    centerPositionOfTheAlarmX = ceil(numberOfRows/2);
    centerPositionOfTheAlarmY = ceil(numberOfRows/2);
%     positionMatrix = zeros(26);
%     centerPositionOfTheAlarmX = 13;
%     centerPositionOfTheAlarmY = 13;
    clusterAlarms = clusterAlarmsConditionalProbability_0_5;
    clusterAlarms_2 = clusterAlarmsConditionalProbability_0_7;
    for i=1:size(clusterAlarms,1)
        [X,Y] = takeAvailablePosition(positionMatrix,centerPositionOfTheAlarmX,centerPositionOfTheAlarmY,mimimumNumberOfGroups);
      %  positionMatrix(X,Y) = i;
        positionMatrix(X,Y) = 1;
        for j=1:nnz(clusterAlarms(i,:))
            coordinatesOfTheAlarms(clusterAlarms(i,j),1) = sizeOfthePointDifference*(rand*0.8 + 0.1 + X);
            coordinatesOfTheAlarms(clusterAlarms(i,j),2) = sizeOfthePointDifference*(rand*0.8 + 0.1 + Y);
        end
        y1=(Y )*sizeOfthePointDifference;    
        y2=(1 + Y)*sizeOfthePointDifference;
        x1=(X )*sizeOfthePointDifference;    
        x2=(1 + X)*sizeOfthePointDifference;
        x = [x1, x2, x2, x1, x1];
        y = [y1, y1, y2, y2, y1];
        plot(x, y, 'b-', 'LineWidth', 1);
        set(gca,'xtick',[])
        set(gca,'ytick',[])
        hold on;
    end
   
        scatter(coordinatesOfTheAlarms(:,1),coordinatesOfTheAlarms(:,2));
        %title('Time between StartTime and EndTime of alarm ');
%         xlabel('Number of times this alarm was triggered');
%         ylabel('Difference in seconds');
        set(gca,'xtick',[])
        set(gca,'ytick',[])
        hold off 
        
end
function [X,Y] = takeAvailablePosition(positionMatrix,X,Y,mimimumNumberOfGroups)
%     X = size(positionMatrix,1)/2;
%     Y = size(positionMatrix,1)/2;]
      constantIncrease = 1;
    if(positionMatrix(X,Y) == 0)
           return;
    end
    constantValue = 1;
    constantValueX = 1;
    constantValueY = 1;
    i = 0;
    while(true)
        if(X - constantValueX > 0 )
          
            if( positionMatrix(X - constantValueX ,Y) == 0)
                X = X - constantValueX; 
           break;
           end
           
                   if( Y + constantValueY  < size(positionMatrix,1) + 1 && positionMatrix(X - constantValueX ,Y + constantValueY ) == 0)
                          X = X - constantValueX;
                          Y = Y + constantValueY; 
                   break;
                   end 
                   if(Y - constantValueY > 0 && positionMatrix(X - constantValueX ,Y - constantValueY ) == 0)
                       X = X - constantValueX;
                       Y = Y - constantValueY; 
                       break;
                   end
                   
       
        end
        
        if(Y - constantValueY > 0 )
           if(positionMatrix(X  ,Y - constantValueY ) == 0)
                Y = Y - constantValueY; 
                break;
           end
        
           if(X + constantValueX  < size(positionMatrix,1) + 1 && positionMatrix(X + constantValueX  ,Y - constantValueY ) == 0)
               X = X + constantValueX;
               Y = Y - constantValueY; 
               break;
           end
        end
        if(Y + constantValueY  < size(positionMatrix,1))
            if(positionMatrix(X  ,Y + constantValueY ) == 0)
               Y = Y + constantValueY; 
               break;
            end 
            if( X + constantValueX  < size(positionMatrix,1)+ 1 && positionMatrix(X + constantValueX  ,Y + constantValueY ) == 0)
                    Y = Y + constantValueY;
                    X = X + constantValueX;
                    break;
            end 


        end
            if( X + constantValueX  < size(positionMatrix,1) + 1 && positionMatrix(X + constantValueX  ,Y ) == 0)
                    X = X + constantValueX;
                    break;
            end 

       
       
       constantValue = constantValue + 1;
       switch rem(i,3)
           case 0
               constantValueX =  constantValueX + constantIncrease;
           case 1
               constantValueX =  constantValueX - constantIncrease;
               constantValueY =  constantValueY + constantIncrease;
           case 2 
               constantValueX =  constantValueX + constantIncrease;
       end
       if( X + constantValueX > size(positionMatrix,1) + 1 && Y + constantValueY > size(positionMatrix,1) + 1)
           constantIncrease = constantIncrease + 1; 
           constantValueX = 1;
           constantValueY = 1;
       end
       i = i + 1;
    end
end
function [related] = checkIfTheAlarmsAreRelated(alarmGroup1,alarmGroup2,clusterWithMinorProbability)
related = false;
for i=1:size(clusterWithMinorProbability,1)
    if(boolean(prod(ismember(alarmGroup1,clusterWithMinorProbability(i,:)))*prod(ismember(alarmGroup2,clusterWithMinorProbability(i,:)))))
        related = true;
    end
end


end