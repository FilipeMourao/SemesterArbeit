function [T,IDMap] = editIDs(T,oID,nID)

%% Create new consecutive IDs
% 
% Input
% T: table
% oID: string, name of old ID column (e.g. alarm name or description)
% nID: string, name of new ID column (unique number for every unique old ID)
if nargin<3 || isempty(nID)
    nID='ID';
end
% Output
% T: table with additional ID column
% IDMap Array to map new IDs to old IDs

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
end









    
   



