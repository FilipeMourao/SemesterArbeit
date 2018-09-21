function [activeAlarms,intVar,tStart,tEnd]=statistics(t,ID,s,interval,tLabel)
%%
% Input
% Example:
% |t=21.09.1990, 19:07:23; ID=17; s=1|
% Alarm with ID=17 becomes active (s=1) at t=21.09.1990, 19:07:23
% |t=21.09.1990, 19:25:20; ID=17; s=0|
% Alarm with ID=17 becomes inactive (s=0) at t=21.09.1990, 19:25:20
% t: date vector
% ID: ID vector
% s: status vector
% interval: time interval (in days) to be considered. If array, plot all
% intervals in linked subplots
% tLabel: type of time labels (e.g. date, week, day...)
if nargin < 5 || isempty(tLabel)
    tLabel = 'date';
end

% Output
% intMean: mean values of active IDs per timepoint in intervals
% intVar: variance of active IDs per time point in intervals
nInt = ceil( (t(end)-t(1))/interval );

%% Initialization
activeAlarms = zeros(nInt,1);
n10Mean = zeros(nInt,1); % Average number of alarms activated within 10 minutes after one alarm
n10Max = zeros(nInt,1);
n10Median = zeros(nInt,1);
n10Var = zeros(nInt,1);
intVar=zeros(nInt,1);
tStart=zeros(nInt,1);
tEnd=zeros(nInt,1);

%% Sort t, ID, s
[~,iSort]=sortrows([t,s],[1,-2]);
t=t(iSort);
ID=ID(iSort);
s=s(iSort);
t1=t(1);
t=t-t(1); % starting at 0

%% Create ID matrix
mID=activeIDs.createMatrix(t,ID,s);
% last=0;
% latest=0;


%% Set time intervals
for i=1:nInt
    tStart(i)=t1+(i-1)*interval;
    tEnd(i)=t1+i*interval;
end


%% Calc average number of active alarms 
nAllrActID=0; % Number of allready active IDs at beginning of interval
for i=1:nInt
    j = logical((t>=(i-1)*interval) & (t<i*interval));
    [activeAlarms(i),nAllrActID]=...
        meanactive(t(j) - (i-1)*interval, mID(j, :), interval, nAllrActID);
    % latest=nActID;
end

%% Calc variance
totalmean=mean(activeAlarms);
for i=1:nInt
    intVar(i)=(activeAlarms(i)-totalmean)^2;
    %x(i)=t1+(i-1)*interval;
end

%% Calc average, max, median, ... number of activated alarms per time interval
for i=1:nInt
    j = logical((t>=(i-1)*interval) & (t<i*interval));
    [n10Mean(i), n10Max(i), n10Median(i), n10Var(i)] = activatedafter(t(j), s(j));
end


plotStats(tStart,{n10Median, min(n10Median,10)},[],tLabel);

%% Plot    
% x=t1:interval:t1+(nInt-1)*interval;
% p=figure();
% bar(x,intMean)    
% title('Mean')
% dateTicks.dynamicDateTicks();
% hold on
% q=figure(2);    
% bar(x,intVar)   
% title('Variance')
% dateTicks.dynamicDateTicks();
end
function [m,idActStart] = meanactive(t,mID,interval,idActStart)
%% Count, how many alarms are active on average per time interval
%    lastc = 0;
    if isempty(t)
%        m=latestc;
        m=idActStart*deltaT; % Wenn kein Eintrag in mID ist die Anzahl der vorherigen Statuse durchgehend aktiv
%        lastc = idActStart;
    else
        % Input
        % T containing 'date','id','status'
        % IDcell containing Cell created by ActiveIDs_cell
        idActive=sum(mID, 2);
%        idActive(1)=idActive(1)+latestc;

        %% Calculate the mean for the given interval
        % m=trapz(Tdate,sum(eidicell,2));
        % d=(T.date(ulimit)-T.date(llimit));
        % m=m/d;
%        m=0;
        m=interval(1)*idActStart;
        for i=2:length(t)
            m=m+(t(i)-t(i-1))*idActive(i);
        end
        m=m+(interval-t(end))*idActive(end);
        m=m/interval;
        % lastc=idActive(length(idActive));
        idActStart=idActive(end);
    end

end
function n = meanactivated(s, interval)
%% Average number of alarms activated within 10 minutes
% Walk through interval in 10 minutes steps and check, how many alarms are
% activated per 10 minutes
% Same result as counting total activations and divide them by 10 minutes
n10 = interval/(10 / (24*60));
n = sum(s) / n10;
end
function [nMean, nMax, nMedian, nVar] = activatedafter(t, s)
%% Number of activated alarms within 10 minutes
% For every alarm: check how many other alarms are activated within the
% next two minutes
% Return the maximum
t = t(s==1);
N = length(t)-1;
n10 = zeros(1, N); % Number of alarms activated within 10 minutes
for i = 1:N
    j = (t >= t(i)) & (t < t(i) + 1/(24*60));
    n10(i) = sum(j);
end

nMean = mean(n10);
nMax = max(n10);
nMedian = median(n10);
nVar = var(n10);
end
function plotStats(tStart,statVals,statNames,tLabel)
%% Plot statistics and link axis, if calculated for several intervals
% Input
% tStart: starting points from intervals (cell array of arrays)
% statVals: cell array of statistical values (numerical arrays)
% statNames: cell array of statistical names

%% Preprocess data
% Transform input to cell arrays
if ~iscell(tStart)
    tStart = {tStart};
end

if ~iscell(statVals)
    statVals = {statVals};
end

if nargin < 3 || isempty(statNames)
    statNames = cell(size(statVals));
elseif ~iscell(statNames)
    statNames = {statNames};
end
if length(statNames) == 1
    multiNames = false;
else
    multiNames = true;
end

% Get number of different plots
N = length(statVals);
if length(tStart) == N
    diffTStart = true; % Different time series for each statistical value
elseif length(tStart) == 1
    diffTStart = false;
end

%% Create subplots
p = gobjects(1,N);

for n=1:N
    % Get time
    if diffTStart
        t = tStart{n};
    else
        t = tStart{1};
    end
    
    % Preper time for plot label
    if strcmpi(tLabel, 'day')
        t = t - t(1);
    elseif strcmpi(tLabel, 'week')
        t = (t - t(1)) / 7;
    end
    
    interval = t(2) - t(1);
    p(n) = repository.tightplot(N,1,n);
    bar(t + interval/2, statVals{n}, 1);
    
    if multiNames
        title( statNames{n} );
    else
        title( statNames{1} );
    end
    
end

linkaxes(p,'x');
if strcmpi(tLabel, 'date')
    dateTicks.dynamicDateTicks(p,1);
end
end