function [T] = deleteChattering(T,t)

%% Delete similar alarms reoccuring within time t in minutes (chattering) 
% 
% Input
% Table T
% time t in minutes  
%
% Output
% Table T

%% %%%%%%%%%%%%%%%%%%%%%

% Check number of inputs
if nargin<2 || isempty(t)
    t = 1;
end

%Sort first for the dates and then for the alarms, now we have a table with alarms with the same id order in time 
T = sortrows(T,'date');
T = sortrows(T,'id');

%% Delete similar alarms reoccuring within time t in minutes (chattering) 
tDiff=t/(24*60);%% convert minutes to days 
rDelete=zeros(height(T),1);

for i=min(T.id):max(T.id)
     
    % All rows of id==i
    iTemp=find(T.id==i);
      
    for j=length(iTemp):-1:2
       
       % All rows within tDiff
       rTemp = (T.id==i)&(T.date>T.date(iTemp(j))-tDiff)&(T.date <= T.date(iTemp(j)));
       
       if T.status(iTemp(j))==1 && sum(rTemp)>1
           
           if T(rTemp,:).status(1)==0

               % Delete all entries           
               rDelete = rDelete + rTemp;
               
           else

               % Delete all except first entry
               firstEntry = ones(height(T),1);

               if sum(rTemp)==length(iTemp)
                   firstEntry(iTemp(end-sum(rTemp)+1))=0;
               else
                   firstEntry(iTemp(end-sum(rTemp)))=0;
               end
               
               rDelete = rDelete + (firstEntry & rTemp);
               
           end
       end
               
    end
      
end

T=T(~rDelete,:);

end

