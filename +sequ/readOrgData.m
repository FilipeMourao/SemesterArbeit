function [T,IDmap]=readOrgData(T)
%% Add counter and IDs to table
%% Input
% T: original OCMA data as importet from CSV
% table with entries TagName, EventTrigger and others
%% Output
% T: preprocessed table with additional entries 
% date (numeric), counter, ID (unique ID for unique TagName)
% IDmap: mapping between ID and TagName. ID n belongs to n-th entry in
% IDmap
%% Output
% Date counter
T.date=datenum(T.date);
T= sortrows(T,'date'); % sort table by date
T.counter=(1:height(T))';
T.Properties.VariableNames(2) = {'ID'};
T(T.status==0,:)=[];

% Unique ID for unique alarm message
IDmap=unique(T.ID); % Return ID-Map: use column index as ID
%T.ID=zeros(height(T),1);
%for i=1:length(IDmap)
%    T.ID(strcmp(T.ID,IDmap(i)))=i;
%end
%% Delete similar alarms reoccuring within 1 minute (chattering) 
tDiff=1/(24*60);
delRow=zeros(height(T),1);
for i=min(T.ID):max(T.ID)
    delTemp=zeros(size(delRow));
    iTemp=find(T.ID==i);
    for j=length(iTemp):-1:2
        if T.date(iTemp(j))-T.date(iTemp(j-1))<tDiff
            delTemp(iTemp(j))=1;
        end
    end
    delRow=delRow+delTemp;
end
T=T(~delRow,:);
end