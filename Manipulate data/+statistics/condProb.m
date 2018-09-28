function [cp,mp] = condProb(t,ID,status,optPar,optZero)
%% Calculate conditional probability
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
% Matrix cp: conditional probability
% mp: mutual probability 

%% sort 
[t,iSort]=sortrows(t);
ID=ID(iSort,:);
status=status(iSort,:);
%% Mutual probability, conditional probability
mp = prob.mutualProb(t,ID,status,optPar,optZero);

%% Conditional probability
cp = zeros(size(mp));

for i = 1:size(mp,2)  
    cp(i,:)=mp(i,:)/mp(i,i);
end


end

