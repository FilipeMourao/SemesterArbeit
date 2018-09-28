function [S,nS] = hirarchicBasedSequ(S0,fMin)
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
% nS: number of sequence occurences. Sequence S(i,:) occurs nS(i) times
%% Find all touples
[S2,nS2] = sequ.lengthBasedSequ(s,2);
% Assign ID and search check to each touple
ID = ones(size(nS2))*max(S0(:))+(1:length(nS2))';
SC = zeros(size(nS2));
%% Use touples to start hirachical clustering
[~,S2,N2,ID,~,~,~] = hirClusterRec(s,S2,nS2,ID,SC,fMin);
%% Transform the ID touples back to alarm sequences
[S,nS] = sequID2alarmID(S2(ID>0,:),ID(ID>0),N2(ID>0));
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
function [s,S,N,ID,SC,nRem,nRemAlt] = hirClusterRec(s,S,N,ID,SC,nMin,nRem,nRemAlt)
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
% S: matrix containing all found sequences (2 alarm IDs or alarm ID +
% sequence ID or 2 sequence IDS)
% N: frequency of respective sequence, same dimension as S
% ID: ID belonging to sequences, same dimension as S
% Every found sequence gets a unique ID (higher than any alarm ID), the
% sequence is then replaced with this ID in s
% e.g. 1,2 -> 1000 if 1000 is ID of sequence 1,2
% SC: search check, specifies if tuple was checked and searched for triples
% already
% nMin: minimum time a sequence has to occur
if nargin<6
    nMin = 2;
elseif nMin<2 || isempty(nMin) || isnan(nMin)
    nMin = 2;
end
% nRem: memory nCell for found sequences
% nRemAlt: alternative memory
if nargin<7
    nRem = zeros(size(N));
    nRemAlt = nRem;
end

%% Output
% Processed inputs necessary to maintain recursive function
[nMax,iMax] = max(N.*~SC); % Only consider those which have not been searched already (SC == 1)

%% Only continue if nMax >= nMin
if nMax >= nMin
    %% Extend matrices S, N, ID, nRem... if neccesary 
    if ID(end)>0
        nRowsAdd = 1000;
        S = [S;zeros(nRowsAdd,2)];
        N = [N;zeros(nRowsAdd,1)];
        ID = [ID;zeros(nRowsAdd,1)];
        SC = [SC;zeros(nRowsAdd,1)];
        nRem = [nRem;zeros(nRowsAdd,1)];
        nRemAlt = [nRemAlt;zeros(nRowsAdd,1)];
    end
    
    %% In s: find the positions of S(iMax,:) and check, how often these occur 
    % in longer sequences (by one alarm)
    iS = strfind(s,S(iMax,:));
    
    % Check how often S(iMax,:) occurs with other messages (triples)
    [S3,nS3] = sequ.lengthBasedSequ(redSequence(s,iS),3);
    
    I = [];
    if ~isempty(nS3)
        if max(nS3)>1   % Triples only occuring once are not of interest
            %% For each new S3: new field in S, N, ID
            % Also: find combination of first two or last two positions in S3
            % in the existing IDs and reduce its numbers
            [IDnew,iNew] = max(ID(:));
            
            % I = find(nS3>1)';   % Replace all alarm combinations with
            % ID(iMAx) more frequent than 1
            [~,I] = max(nS3);     % Only replace most frequent alarm 
            
            % combinations with ID(iMax)
            for i = I
                iSinS3 = strfind(S3(i,:),S(iMax));
                
                if iSinS3 == 1
                    S(iNew+i,:) = [ID(iMax),S3(i,end)]; % New field (ID+end of S3)
                    N = reduceN(S,N,S3(i,2:end),nS3(i)); % Reduce number of occurences 
                else
                    S(iNew+i,:) = [S3(i,1),ID(iMax)];
                    N = reduceN(S,N,S3(i,1:2),nS3(i));
                end
                
                N(iNew+i) = nS3(i);
                ID(iNew+i) = IDnew+i;
                SC(iNew+i) = 0;
                nRem(iNew+i) = 0;
                nRemAlt(iNew+i) = 0;
            end
        end
    end
    
    %% Replace all Scell{iMax} in s with ID 
    % Delete the following field in s
    s(iS) = ID(iMax);
    s(iS+1) = [];
    
    %% Delete old number of occurences and remember it for later analysis
    nRem(iMax) = nMax;
    nRemAlt(iMax) = sum(nS3(I));
    N(iMax) = N(iMax)-sum(nS3(I));
    SC(iMax) = SC(iMax)+1;
    
    %% Recall function
    [s,S,N,ID,SC,nRem,nRemAlt] = hirClusterRec(s,S,N,ID,SC,nMin,nRem,nRemAlt);
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
function [S,N] = sequID2alarmID(S2,ID,N2)
%% Transform ID touples back to alarm sequences
%% Input
% S2: all found ID touples (including pure alarm ID touples)
% ID: IDs represent a touple. field in ID matches field in S
% N2: occurences of touples, reduced if touple is part of a frequent
% triple
%% Output
% S: all found sequences of alarm IDs
% N: number of sequence occurences
%% Build cell array of sequences (unknown lenghts)
m = length(N2);
mNew = sum(N2>0);
SCell = cell(mNew,1);    % Sequences
L = zeros(mNew,1);   % Sequence length
N = zeros(mNew,1);
j = 0;
for i = 1:m
    if N2(i)>0
        j = j+1;
        SCell{j} = sequID2alarmIDRec(S2(i,:),S2,ID);
        L(j) = length(SCell{j});
        N(j) = N2(i);
    end
end
%% Sorting: longest sequences first, sequences of same length: prefer 
% more frequent sequences
[~,iSort] = sortrows([L,N],[-1,-2]);
%% Build output from SCell and N2
N = N(iSort);
S = zeros(mNew,max(L));
for i = 1:mNew
    S(i,1:L(iSort(i))) = SCell{iSort(i)};
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