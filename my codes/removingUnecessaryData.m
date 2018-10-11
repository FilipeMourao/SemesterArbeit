function [tSorted,IDMap] = removingUnecessaryData(T,minimumTime, maximumTime)

%% Create new consecutive IDs
% 
% Input
% T: table
% minimumTime: time in seconds, duration of alarms less than minimumTime 
%is considered chattering 
% maximumTime: time in minutes, duration of alarms greater than 
%maximumTime  is considered
% Output
% T_sorted: table with additional ID column and sorted by time 
% IDMap Array to map new IDs to old IDs
%%Remove number ones
oID = 'FehlerID';%string, name of old ID column (e.g. alarm name or description)
nID = 'UniqueIDs';%string, name of new ID column (unique number for every unique old ID)
rowsToExclude = T.(oID) == 1;
T(rowsToExclude,:) = []; 
if  isempty(minimumTime)
    minimumTime = 10;
end
if  isempty(maximumTime)
    maximumTime = 10;
end


%% remove null values
endingTime = T.('endtime')(:);
rowsWithChatteringTime = zeros(length(endingTime),1);
for i = 1:length(endingTime)
    temporaryString = endingTime(i);
    if( isequal(temporaryString{1},'null'))
        rowsWithChatteringTime(i) = 1;
    end
end
 rowsWithChatteringTime = logical(rowsWithChatteringTime);       
T(rowsWithChatteringTime,:) = []; 

%%remove chattering 
%datenum convert a date in the number of days passed from January 0 ,0000
%we need to convert the days in seconds so we need to multiply by 24*3600
rowsWithChatteringTime = ( datenum(T.('endtime')(:)) - datenum(T.('starttime')(:)) )*24*3600 < minimumTime;
T(rowsWithChatteringTime,:) = [];
%% remove long alarms
rowsWithLongTimeAlarms = ( datenum(T.('endtime')(:)) - datenum(T.('starttime')(:)) )*24*60 > maximumTime;
T(rowsWithLongTimeAlarms,:) = [];
%% sorting by start time 
T = sortrows(T,  find(strcmpi(T.Properties.VariableNames,'starttime')) );
%% Get unique IDs from old column in T
uniqueID=unique(T.(oID));

%% Assign unique number to every unique ID
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
tSorted = T; 
tSorted(:,oID) = [];
end










    
   



