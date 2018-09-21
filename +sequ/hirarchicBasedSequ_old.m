function [S,nS]=hirarchicBasedSequ(S0,lMax,fMin)
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
if size(S0,2)==1; S0=S0'; end % transpose S0-vector if necessary
s=reshapeS(S0); % Reshape S0 to a single vector, seperated by NaN
s=s(s~=0);
% lMax: maximum length of sequences to be found
% fMin: minimum number of occurences
%% Output
% S: sequences found based on hirachical clustering (matrix, same dimension
% and 0-filling as above)
% nS: number of sequence occurences. Sequence S(i,:) occurs nS(i) times
%% Find all touples
[Scell,nCell]=findTouples(s,2);
% Assign ID and search-check to each touple
IDcell=ones(size(nCell))*max(S0(:))+(1:length(nCell))';
%% Use touples to start hirachical clustering
[~,Scell,~,IDcell,nRem,~]=hirCluster(s,Scell,nCell,IDcell,lMax,fMin);
%% Transform the IDs back to alarm sequences
[S,nS]=reTransformIDs(Scell(:,1:end-1),IDcell(:,1:end-1),nRem(:,1:end-1));

%% Find all touples
[S2,nS2]=findTouples(s,2);
% Assign ID to each touple
IDcell=ones(size(nS2))*max(S0(:))+(1:length(nS2))';
%% Use touples to start hirachical clustering
[~,S2,~,IDcell,nRem,~]=hirCluster(s,S2,nS2,IDcell,lMax,fMin);
%% Transform the IDs back to alarm sequences
[S,nS]=reTransformIDs(S2(:,1:end-1),IDcell(:,1:end-1),nRem(:,1:end-1));
end
function S=reshapeS(S0)
m=size(S0,1);
S0=[S0,nan(m,1)];
n=size(S0,2);
temp=zeros(1,m*n);
for i=1:m
    temp((i-1)*n+1:i*n)=S0(i,:);
end
S=temp(1:end-1);
end
function [Scell,n]=findTouples(S0,w)
%% Use function helper.lengthBasedSequ
% Add rows of S to each other and seperate by NaN
[S,n]=helper.lengthBasedSequ(S0,w);
if isempty(n)
    Scell={};
else
    Scell=mat2cell(S,ones(1,size(S,1)),w);
end

end
function [s,Scell,nCell,IDcell,nRem,nRemAlt]=hirCluster(s,Scell,nCell,IDcell,lMax,nMin,nRem,nRemAlt)
%% Perform hirarchical clustering on S (breadth first search)
% Recursive function!
% Most frequent sequence gets replaced by its ID, ID+surrounding alarms are
% then treated as new sequences (of longer length)
% --> recalculate nCell and recall function until shortest sequence (of any
% length<lMAx) occurs less than nMin times
%% Input
% s: row array of all (relevant) alarms, different sequences sepperated
% with NaN
% Scell: cell matrix containing all found sequences
% First column of Scell: all found sequences of length 2
% Second column of Scell: all found sequences of length 3...
% nCell: frequency of respective sequence, same dimension as Scell
% IDCell: ID belonging to sequences, same dimension as Scell
% Every found sequence gets a unique ID (higher than any alarm ID), the
% sequence is then replaced with this ID in s
% e.g. 1,2,3,4 -> 1000,1000,1000,1000 if 1000 is ID of sequence 1,2,3,4
% lMax: maximum length of sequences to be considererd
% nMin: minimum time a sequence has to occur
if nargin<6
    nMin=1;
elseif nMin<1 || isempty(nMin) || isnan(nMin)
    nMin=1;
end
% nRem: memory nCell for found sequences
% nRemAlt: alternative memory
if nargin<7
    nRem=zeros(size(nCell));
    nRemAlt=nRem;
end
%% Output
% Processed inputs necessary to maintain recursive function

%% find sequence occuring the most often
% neglect all nCell with length>lMax 
a=size(Scell,1);
if size(nCell,2)>lMax-1
    nCellTemp=nCell(:,1:lMax-1);
else
    nCellTemp=nCell;
end
[nMax,iMax]=max(nCellTemp(:));
% transform iMax in iCol and iRow
iCol=ceil(iMax/size(Scell,1));
iRow=mod(iMax,size(Scell,1));
if iRow==0
    iRow=size(Scell,1);
end
%% Only continue if nMax>=nMin
if nMax>=nMin
    %% Length of most frequent sequence
    w=iCol+1;
    %% If iMax is (one of) the longest sequences, extend Scell, nCell, IDcell,
    % sCheck to the right
    if iCol==size(Scell,2)
        Scell=[Scell,cell(a,1)];
        nCell=[nCell,zeros(a,1)];
        IDcell=[IDcell,zeros(a,1)];
        nRem=[nRem,zeros(a,1)];
        nRemAlt=[nRemAlt,zeros(a,1)];
    end
    %% In s: find the positions of Scell and check, how often these occur 
    % in longer sequences (by one alarm)
    iS=strfind(s,Scell{iRow,iCol});
    % Check how often Scell{iMAx} occurs with other messages
    [S,n]=helper.lengthBasedSequ(redSequence(s,iS,w),w+1);
    if ~isempty(n)
        %% For each new S: new field in Scell, nCell...
        % find position in IDcell
        iNew=find(IDcell(:,iCol+1)==0);
        if isempty(iNew)
            iNew=size(IDcell,1)+1;
        end
        if iNew(1)+length(n)>iNew(end)
            % More different sequences with w=3 than w=2 could exist
            b=size(Scell,2);
            a=length(n)+iNew(1)-iNew(end);
            Scell=[Scell;cell(a,b)];
            nCell=[nCell;zeros(a,b)];
            IDcell=[IDcell;zeros(a,b)];
            nRem=[nRem;zeros(a,b)];
            nRemAlt=[nRemAlt;zeros(a,b)];
        end
        IDnew=max(IDcell(:))+1;
        for i=0:length(n)-1
            Scell{iNew(1)+i,iCol+1}=S(i+1,:);
            iTemp=strfind(S(i+1,:),Scell{iRow,iCol});
            if iTemp==1
                Scell{iNew(1)+i,iCol+1}(1:end-1)=IDcell(iRow,iCol);
            else
                Scell{iNew(1)+i,iCol+1}(2:end)=IDcell(iRow,iCol);
            end
            nCell(iNew(1)+i,iCol+1)=n(i+1);
            IDcell(iNew(1)+i,iCol+1)=IDnew+i;
        end
        %% For each sequence of length l, that is part of the left or right l 
        % positions of the new l+1 sequences: substract n
        for i=1:size(IDcell,1)
            if IDcell(i,iCol)>0 && IDcell(i,iCol)~=IDcell(iRow,iCol)
                for j=1:length(n)
                    % If Scell{i,l} is part of S(j,:), substract n(j) from
                    % nCell(i,l) and break
                    if ~isempty(strfind(S(j,:),Scell{i,iCol}))
                        nCell(i,iCol)=nCell(i,iCol)-n(j);
                        break;
                    end
                end
            end
        end
    end
    
    %% Replace all Scell{iMax} in s with ID arrays
    for i=0:w-1
        s(iS+i)=IDcell(iRow,iCol);
    end
    %% Delete old number of occurences and remember it for later analysis
    nRem(iRow,iCol)=nMax;
    nRemAlt(iRow,iCol)=sum(n);
    nCell(iRow,iCol)=0;
    %% Recall function
    [s,Scell,nCell,IDcell,nRem,nRemAlt]=hirCluster(s,Scell,nCell,IDcell,lMax,nMin,nRem,nRemAlt);
end
end
function s=redSequence(s0,iS,w)
%% s only contains the positions iS to iS+w from s plus one position 
% earlier and later
S=zeros(length(iS),w+2);
% Fill center of matrix
for i=1:w
    for j=1:length(iS)
        S(j,i+1)=s0(iS(j)+i-1);
    end
end
% Fill left column of matrix
for i=1:length(iS)
    if iS(i)>1
        if ~isnan(s0(iS(i)-1))
            S(i,1)=s0(iS(i)-1);
        end
    end
end
% Fill right column of matrix
for i=1:length(iS)
    if iS(i)+w<length(s0)
        if ~isnan(s0(iS(i)+w))
            S(i,w+2)=s0(iS(i)+w);
        end
    end
end
%% Transform S to array
s=reshapeS(S);
end
function [S,nS]=reTransformIDs(Scell,IDcell,nRem)
%% Transform sequence IDs in Scell back to sequences with pure alarm IDs
m=sum(nRem(:)>0);
S=zeros(m,size(IDcell,2)+1);
nS=zeros(m,1);
%% Go from longest to shortest sequences and fill S and n
iStart=1;
for i=size(Scell,2):-1:1
    iCell=nRem(:,i)>0;
    iS1=iStart;
    iS2=iStart+sum(iCell)-1;
    l=i+1;
    [S(iS1:iS2,1:l),nS(iS1:iS2)]=reTransformIDsCol(Scell(iCell,i),nRem(iCell,i),Scell,IDcell);
    iStart=iStart+sum(iCell);
end
end
function [S,nS]=reTransformIDsCol(Scell,nRem,ScellCompl,IDcellCompl)
%% For all Scell: write to S-matrix and replace sequ ID with alarm ID
m=length(Scell);
l=length(Scell{1});
S=zeros(m,l);
nS=zeros(m,1);
%% The maximal number in Scell{i} is an ID of a shorter sequence
% Replace the ID with its sequence
% Sequence of length 2 contains 2 alarms
% Sequence of length l>2 contains l-1 similar IDs and one actual alarm
for i=1:m
    nS(i)=nRem(i);
    S(i,:)=Scell{i};
    for j=1:l-1
        ID=max(S(i,:));
        S(i,S(i,:)==ID)=ScellCompl{IDcellCompl(:)==ID};
    end
end
%% Sort S and nS based on nS
X=sort([nS,S]);
nS=X(end:-1:1,1);
S=X(end:-1:1,2:end);
end