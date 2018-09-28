function [] = plotIDs(T,IDcell,splitLoc,actIDsPlot)

%% Plot
% Input
% T containing 'date','id','status'
% date: datenum
% id: num
% status: num
% IDcell containing Cell created by ActiveIDs_cell
% splitLoc: 1-> split sum plot to location subplots (opt)
% actIDsPlot: 1 -> only sum plot 
%             2 -> sum & different active IDs

%% Check inputs
if nargin<4
    actIDsPlot=1;
elseif isempty(actIDsPlot)
    actIDsPlot=1;
elseif actIDsPlot==2
else
    actIDsPlot=1;
end

if nargin<3
    splitLoc=0;
elseif isempty(splitLoc)
    splitLoc=0;
elseif splitLoc==0
else
    splitLoc=1;
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T = sortrows(T,'date'); % sort table by date

%% Either plot sum of all active plots or split on locations
if splitLoc==0
    nPlots = 1+actIDsPlot-1;
    p = subplot(nPlots,1,1);
    stairs(T.date,sum(IDcell,2));
    xlabel('date');
    ylabel('number');
elseif splitLoc==1
    %% Get unique locations
    uniLoc=unique(T.location);
    nUniLoc=length(uniLoc);
    %% Create subplot for every unique location
    p=gobjects(1,nUniLoc);
    nPlots = nUniLoc+actIDsPlot-1;
    for i=1:nUniLoc
        p(i)=subplot(nPlots,1,i);
        stairs(T.date,sum(IDcell(:,FindLocIDs(T,uniLoc(i))),2));
        xlabel([uniLoc{i},' date']);
        ylabel('number'); 
    end   
end    

%% Plot active IDs
if actIDsPlot==2    
    p(end+1) = subplot(nPlots,1,nPlots);
	s = pcolor(T.date,1:max(T.id),IDcell.');
    set(s, 'edgecolor', 'none');
    xlabel('date');
    ylabel('id');
end

%% Link axes
linkaxes(p,'x');
%dateTicks.dynamicDateTicks(p,'linked');


end


function IDs=FindLocIDs(T,loc)
%% Return all IDs belonging to the location loc
% Input:
% T: alarm table
% loc: desired location
% Output
% IDs: unique IDs belonging to location
%%
IDs=unique(T.id(strcmp(T.location,loc)));
end
