function [M]=createMatrix(t,ID,s)
%% Generate a matrix (t*n) specifying the active time points of each ID
% Input
% Example:
% |t=21.09.1990, 19:07:23; ID=17; s=1|
% Alarm with ID=17 becomes active (s=1) at t=21.09.1990, 19:07:23
% |t=21.09.1990, 19:25:20; ID=17; s=0|
% Alarm with ID=17 becomes inactive (s=0) at t=21.09.1990, 19:25:20
% t: date vector
% ID: ID vector
% s: status vector
% 
% Output
% M: logical matrix
% For every time point in t, M specifies whether one of the n IDs is active
% or not
%


%% Check number of inputs
if nargin<4 || isempty(opt)
    opt = 0; 
end


%% Sort t, ID and s w.r.t. date and status
[~,iSort]=sortrows([t,s],[1,2]); % - gelöscht
t=t(iSort);
ID=ID(iSort);
s=s(iSort);
%% Create and fill matrix M
uniqueID=unique(ID);
M=zeros(length(t),length(uniqueID)); % allocate storage for whole matrix

    for i = 1:length(uniqueID)

        i0 = find(logical((s==0) .* (ID==uniqueID(i))));    
        i1 = find(logical((s==1) .* (ID==uniqueID(i))));

        for j=1:length(i1)
            row1=i1(j);
            row0=i0(i0>=row1);
            if isempty(row0)
                row0=length(t)+1;
            else
                row0=row0(1);
            end
            
            M(row1:row0-1,i)=1;
            
        end

    end
    
end