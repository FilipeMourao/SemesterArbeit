function [T] = editStatus(T,oStatus,nStatus,eOne,eZero)

%% Create new Status with 0,1 
% Input
% Table T 
% opt. String oStatus: Name of old status column
%  (otherwise oStatus = 'status')
% opt. String nStatus: Name of new status column
%  (otherwise nStatus = NewStatus)
% opt. Cell eOne: Old status values -> 1
%  (otherwise options = {'+'})
% opt. Cell eZero: Old status values -> 0
%  (otherwise options = {'-'})  
%
% Output
% Table T

%% Check number of inputs
if nargin<5 || isempty(eZero)
    eZero = {'-'}; 
end

if nargin<4 || isempty(eOne)
    eOne = {'+'}; 
end
% Convert eZero and eOne to cell array
eOne=convert2cell(eOne);
eZero=convert2cell(eZero);

if nargin<3 || isempty(nStatus)
    nStatus='NewStatus';
end

if nargin<2 || isempty(oStatus)
    oStatus='status';
    nStatus='NewStatus';
end

%% Check for correct inputs
if sum(strcmp(oStatus,T.Properties.VariableNames))==0 
    error('Column doesnt exist')
end


rOne = zeros(size(T.(oStatus)));
rZero = zeros(size(T.(oStatus)));

%% Set Status 1
for i = 1:length(eOne)
    if ischar(eOne{i})
        rOne = rOne + strcmp(T.(oStatus),eOne{i});
    else
        rOne = rOne + (T.(oStatus)==eOne{i});
    end
end
    T.(nStatus)(logical(rOne),1)=1;

%% Delete entrys except 0,1
for i = 1:length(eZero)
    if ischar(eZero{i})
        rZero = rZero + strcmp(T.(oStatus),eZero{i});
    else
        rZero = rZero + (T.(oStatus)==eZero{i});
    end
end
    T(~rOne & ~rZero,:)=[];
       
end
function x=convert2cell(x)
%% Convert x to a cell array
if ~iscell(x)
    if isnumeric(x)
        x=num2cell(x,1,ones(size(x)));
    else
        x={x};
    end
end
end

