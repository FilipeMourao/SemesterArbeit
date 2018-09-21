function [S,T]=neglLowRates(S0,t,rStart,rEnd,deltaT)
%% Find sequences based on fullen strategy
% Sequence starts when alarm rate exceeds 1alarms/10minutes (rStart) and 
% stops once the alarm rate falls below 5alarms/10minutes (rEnd)
%% Input
% S0: vector of alarms IDs (Nx1) (entire sequence)
% t: data of alarm activation (Nx1)
% rStart: alarm rate (per 10 minutes) specifying start of sequence 
% (e.g. sequence starts once alarm rate exceeds 1alarms/10minutes)
if nargin<3 || isempty(rStart)
    rStart=1;
end
% rEnd: alarm rate (per 10 minutes) 
if nargin<4 || isempty(rEnd)
    rEnd=1;
end
% deltaT: optional, changes 'per 10 minutes' to 'per deltaT minutes'
if nargin<5 || isempty(deltaT)
    deltaT=10/(24*60);
else
    deltaT=deltaT/(24*60);
end
%% Output
% S: sequences, split based on rStart and rEnd
% S as matrix (n(sequences)*max sequ length)
% shorter sequences are filled with zeros
% T: dates to sequence alarms, same structure as S
%% Find start and end of each sequence
[iStart,iEnd]=splitSequ(t,rStart,rEnd,deltaT);
S=zeros(length(iStart),max(iEnd-iStart)+1);
T=S;
for i=1:length(iStart)
    S(i,1:iEnd(i)-iStart(i)+1)=S0(iStart(i):iEnd(i))';
    T(i,1:iEnd(i)-iStart(i)+1)=t(iStart(i):iEnd(i))';
end
end
function [iStart,iEnd]=splitSequ(t,rStart,rEnd,deltaT)
%% Get the start and end indexes from sequences in t
%% Input
% t: data of alarm activation (Nx1)
% rStart: alarm rate (per 10 minutes) specifying start of sequence 
% (e.g. sequence starts once alarm rate exceeds 10alarms/deltaT)
% rEnd: alarm rate (per deltaT) 
% deltaT: e.g. 10 minutes
N=length(t);
iStart=[];
iEnd=[];
i=0;
while i<N
    i=i+1;
    % Count how many alarms occur within deltaT
    if sum((t>=t(i)).*(t<(t(i)+deltaT)))>rStart 
        iStart(1,end+1)=i;
        while i<N
            i=i+1;
            % Count how many alarms occur within deltaT
            if sum((t>t(i)).*(t<(t(i)+deltaT)))<rEnd
                iEnd(1,end+1)=i;
                break;
            end
        end
    end
end
% If last alarms had rate of higher than rEnd/deltaT
if length(iEnd)<length(iStart)
    iEnd(1,end+1)=N;
end
end