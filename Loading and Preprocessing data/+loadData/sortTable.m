function [newTable] = sortTable(inputTable,date,id,status,location)

%% Expl.
% Input
% inputTable: table from DB cont...
% date:
%   string: 'Date'
%   cell array of strings: {'Date','Milisec'}
% id
% status

% Output
% newTable containing 'date','id','status' sorted by date

%% TODO Remove NaN Cells
%inputTable(cellfun(@isnan, inputTable.(date{1}),'UniformOutput',0)) = [];

%inputTable(isnan(inputTable.(date{1}))) = []; % delete empty rows


%% change status to 0,1

    NewStatus = zeros(size(inputTable.(status))); % preallocation for speed
    
    for i=1:length(inputTable.(status))
        
        if strcmp(inputTable.(status)(i),'+')==1
            NewStatus(i,1)=1;
        elseif strcmp(inputTable.(status)(i),'-')==1
            NewStatus(i,1)=0;
        else
            NewStatus(i,1)=2;
        end
        
    end

    
%% pot. combine Date and Milisec
    if iscell(date)==1
   
        newDate_str = cell(size(inputTable.(date{1}))); % preallocation for speed
        
        % combine colums to one date string
        for i=1:length(inputTable.(date{1}))
            i
            newDate = addtodate(datenum(inputTable.(date{1})(i)),inputTable.(date{2})(i),'millisecond');  
            newDate_str{i,1} = datestr(newDate,'dd-mm-yyyy HH:MM:SS.FFF');
        end
        
        newDate = datetime(newDate_str,'InputFormat','dd-MM-yyyy HH:mm:ss.SSS','Format','preserveinput'); % convert to datetime format  
    else
        newDate = inputTable.(date);        
    end
    

%% new table
    newTable = table(newDate,inputTable.(id),NewStatus,inputTable.(location)); % create new table
    newTable.Properties.VariableNames = {'date','id','status','location'}; % rename labels
    newTable = sortrows(newTable,'date'); % sort table by date 
    newTable.date = datenum(newTable.date); % Datenum Format
    
    newTable(newTable.status == 2,:) = []; % delete entries with status 2
    newTable = unique(newTable); % only unique entries

end

