function  plottingTransferEntropyRelatedAlarms() 
    clusterNames = [
        "clusterAlarmsTransferEntropy10-2.mat"
         "clusterAlarmsTransferEntropy10-3.mat"
         "clusterAlarmsTransferEntropy10-4.mat"
         "clusterAlarmsTransferEntropy10-5.mat"
        
    ]
 %   numberOfClusters = 2;
    %%Ploting the first points in the most distant group
    clusterAlarms = cell2mat(struct2cell(load('relatedAlarmsTransferEntropy/' + clusterNames(1))));
    numberOfClusters = size(clusterNames,1);
    coordinatesOfTheAlarms = zeros(size(clusterAlarms,2),2);
    valueToIncreasePerGroup = 1;
    %zoomPerCluster = 100;
    zoomArray = [];
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
        zoomPerCluster = getZoom(size(clusterAlarms,1));
        zoomArray = [zoomArray,zoomPerCluster];
        valueToIncreasePerGroup = valueToIncreasePerGroup*zoomPerCluster;
        clusterAlarms = cell2mat(struct2cell(load('relatedAlarmsTransferEntropy/' + clusterNames(k))));
        for i=1:size(clusterAlarms,1)
            increasePerGroup =  (i + 0.3)*valueToIncreasePerGroup;
            for j=1:nnz(clusterAlarms(i,:))
                coordinatesOfTheAlarms(clusterAlarms(i,j),1) = coordinatesOfTheAlarms(clusterAlarms(i,j),1)+ increasePerGroup ;%x
                coordinatesOfTheAlarms(clusterAlarms(i,j),2) = coordinatesOfTheAlarms(clusterAlarms(i,j),2) + increasePerGroup ;%y
            end
        end
    end
    colors =["b-";"k-";"r-";"c-";"g-";"m-"];
    %% Plotting the results
    valueToIncreasePerGroup = 1;
    for k=1:numberOfClusters
        clusterAlarms = cell2mat(struct2cell(load('relatedAlarmsTransferEntropy/' + clusterNames(k))));
        for i=1:size(clusterAlarms,1)
            zoomValue = zoomIn(zoomArray,k);
            xDeslocation = floor(coordinatesOfTheAlarms(clusterAlarms(i,1),1)/zoomValue)*zoomValue;
            yDeslocation  = floor(coordinatesOfTheAlarms(clusterAlarms(i,1),2)/zoomValue)*zoomValue;
            y1 = yDeslocation;    
            y2= valueToIncreasePerGroup + yDeslocation;
            x1= xDeslocation;   
            x2=valueToIncreasePerGroup + xDeslocation;
            x = [x1, x2, x2, x1, x1];
            y = [y1, y1, y2, y2, y1];
            plot(x, y, colors(k), 'LineWidth', 1);
            set(gca,'xtick',[])
            set(gca,'ytick',[])
            hold on;
        end
        if k < numberOfClusters
                 valueToIncreasePerGroup = valueToIncreasePerGroup*zoomArray(k);
        end
    end
        scatter(coordinatesOfTheAlarms(:,1),coordinatesOfTheAlarms(:,2));
        %title('Time between StartTime and EndTime of alarm ');
%         xlabel('Number of times this alarm was triggered');
%         ylabel('Difference in seconds');
        set(gca,'xtick',[])
        set(gca,'ytick',[])
        hold off;
        %        legend({'0.8','0.7','0.6','0.55','0.5','alarms'},'Location','north')
        
end
function [zoomValue] = zoomIn(zoomMatrix, numberToPower)
    zoomValue = 1;
    for i=1:numberToPower-1
        zoomValue = zoomValue*zoomMatrix(i);
    end
end
function [zoom] = getZoom(numberOfClusters) 
    zoom = 1;
    if numberOfClusters < 10 
        zoom = 10;
    end
    if numberOfClusters > 10 && numberOfClusters < 100
        zoom = 100;
    end
    if numberOfClusters > 100 && numberOfClusters < 1000
        zoom = 1000;
    end
end
