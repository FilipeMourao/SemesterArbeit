function [T] = datenumTable(T,oDate,nDate)

%% Convert date to Datenum Format
% 
% Input
% Table T
% String oDate with name of old date column
% opt. String nDate with name of new date column (otherwise column stays the same)
%
% Output
% Table T

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check number of inputs
if nargin<2 || isempty(oDate)
    oDate='date';
    nDate=oDate;  
elseif nargin<3 || isempty(nDate)
    nDate=oDate;
end

% Check for correct inputs
if sum(strcmp(oDate,T.Properties.VariableNames))==0 
    error('Column doesnt exist')
end

% Datenum Format
T.(nDate) = datenum(T.(oDate)); 

end

