function [S,nTotal,nRelative] = hirarchicBasedSequ_2(S0,fMin)
%% Find sequences based on hirarchical clustering
% For method description see
% {B. Vogel-Heuser, D. Schütz, and J. Folmer, “Criteria-based alarm flood 
% pattern recognition using historical data from automated production 
% systems (aPS),” Mechatronics, vol. 31, pp. 89–100, 2015.}
% Find the most frequent tuple of sequences s{1,1}
% Based on this tuple, find the most frequent triple s{1,2}
% If num(s{1,2})<num(s{2,1}), find most frequent triple based on second
% most frequent tuple, otherwise continue search for most frequent
% quatruple. 
%% Input
% S0: (matrix or vector) of alarm IDs
% if vector: one sequence containing all alarms
% if (m*n) matrix: m (prefiltererd) sequences of maximum length n, shorter
% sequences are filled with 0
if size(S0,2) == 1; S0 = S0'; end % transpose S0-vector if necessary
s = reshapeS(S0); % Reshape S0 to a single vector, seperated by NaN
s = s(s ~=  0);
% lMax: maximum length of sequences to be found
% fMin: minimum number of occurences
%% Output
% S: sequences found based on hirachical clustering (matrix, same dimension
% and 0-filling as above)
% nTotal: total number the sequence was found in s
% nRelative: if sequence AB is part of sequence ABC, the number of ABC
% occuring in s is substracted of nRelative of AB

%% Hirachical clustering
[~,S2,ID] = hirClusterRec(s,[],[],fMin);

%% Transform the ID touples back to alarm sequences
S = sequID2alarmID(S2,ID);

%% Count how often each sequence occurs
[nTotal,nRelative] = countSequences(s,S);

end
function S = reshapeS(S0)
m = size(S0,1);
S0 = [S0,nan(m,1)];
n = size(S0,2);
temp = zeros(1,m*n);
for i = 1:m
    temp((i-1)*n+1:i*n) = S0(i,:);
end
S = temp(1:end-1);
end
function [s,S2,ID] = hirClusterRec(s,S2,ID,nMin)
%% Perform hirarchical clustering on s (breadth first search)
% Recursive function!
% Most frequent sequence gets replaced by its ID, ID+surrounding alarms are
% then treated as new sequences (of 2)
% --> recalculate N and recall function until most frequent sequence 
% occurs less than nMin times
%% Input
% s: row array of all (relevant) alarms, different sequences sepperated
% with NaN, 0 entries must be neglected
s = s(s ~=  0);
% N: frequency of respective sequence, same dimension as S
% ID: ID belonging to sequences, same dimension as S
% Every found sequence gets a unique ID (higher than any alarm ID), the
% sequence is then replaced with this ID in s
% e.g. 1,2 -> 1000 if 1000 is ID of sequence 1,2
% nMin: minimum time a sequence has to occur
if nargin<5 || nMin<2 || isempty(nMin) || isnan(nMin)
    nMin = 2;
end

%%
% Find the most frequent touple in s
[touples,nTouple] = sequ.lengthBasedSequ(s, 2);

% Only continue if nMax >= nMin
if nTouple(1) >= nMin  
    % Create a new ID for the most frequent touple
    if isempty(ID)
        newID = nanmax(s) + 1;
        ID = newID;
        S2 = touples(1,:);
    else
        newID = max(ID) + 1;
        ID = [ID; newID];
        S2 = [S2; touples(1, :)];
    end
    
    % Replace the touple in s with its new ID
    iS = strfind(s, S2(end, :));
    s(iS) = ID(end);
    s(iS+1) = [];
    
    % Call the function again
    [s,S2,ID] = hirClusterRec(s,S2,ID,nMin);
end
end
function s = redSequence(s0,iS)
%% s only contains the positions iS-1:iS+2
S = zeros(length(iS),4);
% Fill center of matrix
for i = 1:length(iS)
    S(i,2:3) = s0(iS(i):iS(i)+1);
end

% Fill left column of matrix
for i = 1:length(iS)
    if iS(i)>1
        if ~isnan(s0(iS(i)-1))
            S(i,1) = s0(iS(i)-1);
        end
    end
end

% Fill right column of matrix
for i = 1:length(iS)
    if iS(i)+1<length(s0)
        if ~isnan(s0(iS(i)+2))
            S(i,end) = s0(iS(i)+2);
        end
    end
end
%% Transform S to array
s = reshapeS(S);
end
function N = reduceN(S,N,s,n)
%% Search s in S and reduce its N by n
for i = 1:length(N)
    if isequal(S(i,:),s)
        N(i) = N(i)-n;
        break;
    end
end
end
function S = sequID2alarmID(S2,ID)
%% Transform ID touples back to alarm sequences
%% Input
% S2: all found ID touples (including pure alarm ID touples)
% ID: IDs represent a touple. field in ID matches field in S

%% Output
% S: all found sequences of alarm IDs
% N: number of sequence occurences
%% Build cell array of sequences (unknown lenghts)
m = length(ID);
SCell = cell(m,1);    % Sequences
L = zeros(m,1);   % Sequence length

for i = 1:m
    SCell{i} = sequID2alarmIDRec(S2(i,:),S2,ID);
    L(i) = length(SCell{i});
end

%% Build output from SCell and N2
% Sort w.r.t. sequence length
[~, iSort] = sortrows(L, -1);

S = zeros(m, max(L));
j = 0;
for i = iSort'
    j = j+1;
    S(j, 1:L(i) ) = SCell{i};
end

end
function s = sequID2alarmIDRec(s0,allS2,allIDs)
%% Replace ID (highest number in sID) with its touple
ID = max(s0);
if ID >= min(allIDs)
    iID0 = find(s0 == ID);     % find ID in s0
    nOccur = length(iID0);   % Count how often ID occurs
    %% Translate positions in s0 to positions in s
    iID = zeros(size(iID0));
    for i = 1:nOccur
        iID(i) = iID0(i)+i-1;
    end
    %% Fill s
    s = zeros(1,size(s0,2)+nOccur);
    if iID(1) == 1
        s(1:2) = allS2(allIDs == ID,:);
    else
        s(iID(1):iID(1)+1) = allS2(allIDs == ID,:);
        s(1:iID(1)-1) = s0(1:iID0(1)-1);
    end
    for i = 2:nOccur
        s(iID(i):iID(i)+1) = allS2(allIDs == ID,:);
        s(iID(i-1)+2:iID(i)-1) = s0(iID0(i-1)+1:iID0(i)-1);
    end
    if iID0(end)<length(s0)
        s(iID(end)+2:end) = s0(iID0(end)+1:end);
    end
    %% Recall function
    s = sequID2alarmIDRec(s,allS2,allIDs);
else
    s = s0;
end
end
function [nTotal, nRelative] = countSequences(s, S)
%% Count how eften sequences in S occur in s
m = size(S,1);
nTotal = zeros(m, 1);
nRelative = zeros(m,1);
sRelative = s;

for i = 1:m
    sTemp = S(i, S(i,:)>0);
    n = length(sTemp);
    deleteSequ = false( size(sRelative) );
    nTotal(i) = length( strfind(s, sTemp) );
    
    iRelative = strfind( sRelative, sTemp );
    nRelative(i) = length( iRelative );
    for j = 0:n-1
        deleteSequ(iRelative + j) = true;
    end
    
    sRelative = sRelative(~deleteSequ);
end
end