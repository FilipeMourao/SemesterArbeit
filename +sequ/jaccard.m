function [J,p]=jaccard(S0,bPlot)
%% Jaccard distance between sequences in S
%% Input
% S: matrix, rows are observations
% bPlot (optional): if 1, plot 
if nargin<2; bPlot=0; elseif isempty(bPlot); bPlot=0; end
%% Output
% J: Jaccard matrix, J(i,j) is jaccard index of comparison between the two
% (different) sequences S(i,:) and S(j,:)
% p: handle to plot
%% Create a matrix only containing unique messages of all sequences
S=zeros(size(S0));
nUnique=zeros(size(S0,1),1);
m=size(S,1);
for i=1:m
    temp=unique(S0(i,:));
    nUnique(i)=length(temp);
    S(i,1:nUnique(i))=temp;
end
%% Create matrix and calculate lower triangle
J=zeros(m);
parfor i=1:m-1
    J(i,:)=parjaccard(S,i,nUnique);
end
%% Complete matrix
J=J+J'+eye(size(J));
if bPlot==1
    p=pcolor(J);
    set(p, 'edgecolor', 'none');
else
    p=[];
end
end
function j=parjaccard(S,k,nUnique)
%% Calculate jaccard index for every entry after i
m=size(S);
j=zeros(1,m(1));
for i=k+1:m(1)
    temp=length(intersect(S(k,1:nUnique(k)),S(i,1:nUnique(i))));
    if temp==0
        j(i)=0;
    else
        j(i)=temp/length(unique([S(k,1:nUnique(k)),S(i,1:nUnique(i))]));
    end
end
end