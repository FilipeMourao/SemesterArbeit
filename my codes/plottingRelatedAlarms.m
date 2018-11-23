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
    sizeOfthePointDifference = 100;
    clusterAlarmsConditionalProbability_0_1 = cell2mat(struct2cell(load('relatedAlarmsByProbability/clusterAlarmsConditionalProbability_0.1.mat')));
    clusterAlarmsConditionalProbability_0_2 = cell2mat(struct2cell(load('relatedAlarmsByProbability/clusterAlarmsConditionalProbability_0.2.mat')));
    clusterAlarmsConditionalProbability_0_3 = cell2mat(struct2cell(load('relatedAlarmsByProbability/clusterAlarmsConditionalProbability_0.3.mat')));
    clusterAlarmsConditionalProbability_0_4 = cell2mat(struct2cell(load('relatedAlarmsByProbability/clusterAlarmsConditionalProbability_0.4.mat')));
    clusterAlarmsConditionalProbability_0_5 = cell2mat(struct2cell(load('relatedAlarmsByProbability/clusterAlarmsConditionalProbability_0.5.mat')));
    coordinatesOfTheAlarms = zeros(size(clusterAlarmsConditionalProbability_0_4,2),2);
    positionMatrix = zeros(26);
    centerPositionOfTheAlarmX = 13;
    centerPositionOfTheAlarmY = 13;
    clusterAlarms = clusterAlarmsConditionalProbability_0_5;
    for i=1:size(clusterAlarms,1)
        [X,Y] = takeAvailablePosition(positionMatrix,centerPositionOfTheAlarmX,centerPositionOfTheAlarmY);
        positionMatrix(X,Y) = i;
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
function [X,Y] = takeAvailablePosition(positionMatrix,X,Y)
%     X = size(positionMatrix,1)/2;
%     Y = size(positionMatrix,1)/2;
    if(positionMatrix(X,Y) == 0)
            return;
    end
    constantValue = 1;
    constantValueX = 1;
    constantValueY = 1;
    i = 0;
    while(true)
       if(positionMatrix(X - constantValueX ,Y) == 0)
           X = X - constantValueX; 
           break;
       end 
        if(positionMatrix(X - constantValueX ,Y + constantValueY ) == 0)
           X = X - constantValueX;
           Y = Y + constantValueY; 
           break;
        end
       
        if(positionMatrix(X  ,Y + constantValueY ) == 0)
           Y = Y + constantValueY; 
           break;
       end 

       
       if(positionMatrix(X + constantValueX  ,Y + constantValueY ) == 0)
           Y = Y + constantValueY;
           X = X + constantValueX;
           break;
       end 
       
       if(positionMatrix(X + constantValueX ,Y) == 0)
           X = X + constantValueX; 
           break;
       end
       
       if(positionMatrix(X + constantValueX  ,Y - constantValueY ) == 0)
           X = X + constantValueX;
           Y = Y - constantValueY; 
           break;
       end
       if(positionMatrix(X  ,Y - constantValueY ) == 0)
           Y = Y - constantValueY; 
           break;
       end
       
       if(positionMatrix(X - constantValueX ,Y - constantValueY ) == 0)
           X = X - constantValueX;
           Y = Y - constantValueY; 
           break;
       end
       
       constantValue = constantValue + 1;
       switch rem(i,3)
           case 0
               constantValueX =  constantValueX + 1;
           case 1
               constantValueX =  constantValueX - 1;
               constantValueY =  constantValueY + 1;
           case 2 
               constantValueX =  constantValueX + 1;
       end
       i = i + 1;
    end
end