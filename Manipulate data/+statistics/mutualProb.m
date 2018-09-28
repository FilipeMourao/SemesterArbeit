function [p] = mutualProb(t,ID,status,optPar,optZero)
%% Calculate mutual probability
%
% Input
% t: date vector
% ID: ID vector
% status: status vector
% optPar: option for parallel computing (optional)
if nargin<4 || isempty(optPar)
    optPar=0;
end
% Output
% Matrix p with probability
%% sort 
[t,iSort]=sortrows(t);
ID=ID(iSort,:);
status=status(iSort,:);
%% Get ID array
IDarray = activeIDs.createMatrix(t,ID,status);
%% Duration of every time step in IDarray
% (Durration of last recording must be assumed to be 0)
tDurr = [t(2:end) - t(1:end-1) ; 0];
tTotal = t(end) - t(1); 
%% Probability, that alarm i and j are active at the same time
p = zeros(size(IDarray,2), size(IDarray,2));

if optZero
   IDarray = ~IDarray; 
end

if optPar
    parfor i = 1:size(IDarray,2)
        p(i,:) = iMutualProb(IDarray, tDurr, tTotal, i);
    end
else
    for i = 1:size(IDarray,2)
        p(i,:) = iMutualProb(IDarray, tDurr, tTotal, i);
    end
end

% Symetric matrix 
p=p+p'-eye(size(p)).*p; 

end
function p=iMutualProb(IDarray, tDurr, tTotal, i)
%% Probability, that alarm i and j are active at the same time
% (for j >=i)
% Input:
% IDarray: IDarray(r,i)=1, if alarm i is active at row r
% tDurr: tDurr(t) is the durration of row r
% tTota: total time (sum of tDurr)
% i: index of alarm i
p = zeros(1,size(IDarray,2));
for j = i:size(IDarray,2)
    % Rows when i and j is active
    r = (IDarray(:,i) & IDarray(:,j));
    if sum(r) == 0
        p(j) = 0;
    else
        p(j) = sum( tDurr(r) )/tTotal; 
    end

end
end
