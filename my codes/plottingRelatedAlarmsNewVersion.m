function  plottingRelatedAlarms() 
    clusterNames = [
        "clusterAlarmsConditionalProbability_0.8.mat"
         "clusterAlarmsConditionalProbability_0.7.mat"
        "clusterAlarmsConditionalProbability_0.6.mat"
        "clusterAlarmsConditionalProbability_0.55.mat"
        "clusterAlarmsConditionalProbability_0.5.mat"
        
    ]
    numberOfClusters = size(clusterNames,1);
    %%Ploting the first points in the most distant group
    clusterAlarms = cell2mat(struct2cell(load('relatedAlarmsByProbability/' + clusterNames(1))));
    coordinatesOfTheAlarms = zeros(size(clusterAlarms,2),2);
    plotDeslocation = 0;
    valueToIncreasePerGroup = 1;
    zoomPerCluster = 100;
    for i=1:size(clusterAlarms,1)
           for j=1:nnz(clusterAlarms(i,:))
                coordinatesOfTheAlarms(clusterAlarms(i,j),1) = coordinatesOfTheAlarms(clusterAlarms(i,j),1)...
                + (round(rand,3)*0.5 + 0.2 + i )*valueToIncreasePerGroup;%x
                coordinatesOfTheAlarms(clusterAlarms(i,j),2) =coordinatesOfTheAlarms(clusterAlarms(i,j),2)...
                + (round(rand,3)*0.5 + 0.2 + i  )*valueToIncreasePerGroup;%y
          end
     end
%% joining groups together
    for k=2:numberOfClusters
        valueToIncreasePerGroup = valueToIncreasePerGroup*zoomPerCluster;
        plotDeslocation = plotDeslocation + valueToIncreasePerGroup;
        clusterAlarms = cell2mat(struct2cell(load('relatedAlarmsByProbability/' + clusterNames(k))));
        for i=1:size(clusterAlarms,1)
            increasePerGroup =  i*valueToIncreasePerGroup;
            for j=1:nnz(clusterAlarms(i,:))
                coordinatesOfTheAlarms(clusterAlarms(i,j),1) = coordinatesOfTheAlarms(clusterAlarms(i,j),1)+ increasePerGroup ;%x
                coordinatesOfTheAlarms(clusterAlarms(i,j),2) =coordinatesOfTheAlarms(clusterAlarms(i,j),2) + increasePerGroup ;%y
            end
        end
    end
    colors =["b-";"k-";"r-";"c-";"g-";"m-"];
    %% Plotting the results
    valueToIncreasePerGroup = 1;
    for k=1:numberOfClusters
        clusterAlarms = cell2mat(struct2cell(load('relatedAlarmsByProbability/' + clusterNames(k))));
        for i=1:size(clusterAlarms,1)
            xDeslocation = 0;
            yDeslocation  = 0;
            if( k < numberOfClusters)
                   xDeslocation = round(coordinatesOfTheAlarms(clusterAlarms(i,1),1)/(zoomPerCluster^k))*zoomPerCluster^k;
                   yDeslocation  = round(coordinatesOfTheAlarms(clusterAlarms(i,1),2)/(zoomPerCluster^k))*zoomPerCluster^k;
            end
            y1 =(i)*valueToIncreasePerGroup + yDeslocation;    
            y2=(i+ 1)*valueToIncreasePerGroup + yDeslocation;
            x1=(i)*valueToIncreasePerGroup + xDeslocation;   
            x2=(i + 1)*valueToIncreasePerGroup + xDeslocation;
            x = [x1, x2, x2, x1, x1];
            y = [y1, y1, y2, y2, y1];
            plot(x, y, colors(k), 'LineWidth', 1);
    %        set(gca,'xtick',[])
     %       set(gca,'ytick',[])
            hold on;
        end
         valueToIncreasePerGroup = valueToIncreasePerGroup*zoomPerCluster;
         plotDeslocation = plotDeslocation - valueToIncreasePerGroup;
    end   
        scatter(coordinatesOfTheAlarms(:,1),coordinatesOfTheAlarms(:,2));
        %title('Time between StartTime and EndTime of alarm ');
%         xlabel('Number of times this alarm was triggered');
%         ylabel('Difference in seconds');
   %     set(gca,'xtick',[])
   %     set(gca,'ytick',[])
        hold off 
        
end

