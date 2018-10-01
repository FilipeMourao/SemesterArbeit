function [T_sorted,IDMap] = removingUnecessaryData(T,t)

%% Create new consecutive IDs
% 
% Input
% T: table
% oID: string, name of old ID column (e.g. alarm name or description)
% nID: string, name of new ID column (unique number for every unique old ID)

% Output
% T: table with additional ID column
% IDMap Array to map new IDs to old IDs
%%Remove number ones
oID = 'FehlerID';
nID = 'UniqueIDs';
rowsToExclude = T.(oID) == 1;
T(rowsToExclude,:) = []; 
%% Get unique IDs from old column in T
if nargin<2 || isempty(t)
    t = 10;
end
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
T_sorted = sortrows(T,nID); 
T_sorted(:,oID) = [];
%% remove null values
endingTime = T_sorted.('endtime')(:);
rowsWithChatteringTime = zeros(length(endingTime),1);
for i = 1:length(endingTime)
    temporaryString = endingTime(i);
    if( isequal(temporaryString,'null'))
        rowsWithChatteringTime(i) = 1;
    end
end
 rowsWithChatteringTime = logical(rowsWithChatteringTime);       
T_sorted(rowsWithChatteringTime,:) = []; 


%%remove chattering 
rowsWithChatteringTime = ( datenum(T_sorted.('endtime')(:)) - datenum(T_sorted.('starttime')(:)) )*24*3600 < t;
T_sorted(rowsWithChatteringTime,:) = [];
end










    
   



