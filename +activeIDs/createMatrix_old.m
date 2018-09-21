function [M] = createMatrix_old(T,opt)

%% Generate matrix (column: id, row: timestep)
% Input
% Table T containing 'date','id','status'
% date: datenum
% id: num
% status: num
%
% opt: 0 -> 1/0 for active/inactive alarms
%      1 -> 1 when alarm is activated otherwise 0
%
% Output
% Matrix M (column: id, row: timestep) with 1/0 for active/inactive alarms

%% Check inputs
if nargin<2
    opt=0;
elseif isempty(opt)
    opt=0;
elseif opt==1
else
    opt=0;
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sort table by id & date
T = sortrows(T,'id'); 
T = sortrows(T,'date'); 

% Output Matrix
M = zeros(length(T.date),max(T.id));

if opt==0
    
    %% Generate matrix (column: id, row: timestep) with 1/0 for active/inactive alarms

    % Array of active IDs
    activeIDs = zeros(1,1);

    for i = 1:size(T,1)    
        % find current ID in activeIDs
        j = find(activeIDs==T.id(i),1);

        if T.status(i) == 1 && isempty(j)== 1 

            % Add new activeID
            activeIDs(end+1,1) = T.id(i);         
            % Delete empty rows (i=1)
            activeIDs(activeIDs==0,:) = []; 

        elseif T.status(i) == 0 && isempty(j)==0

            % Delete Old activeID
            activeIDs(j,:) = [];   

        end  

        % Set IDs to active
        M(i,activeIDs)=1;       
    end

elseif opt==1
    
    %% Generate matrix (column: id, row: timestep) with entry 1 when alarm is activated

    for i = 1:size(T,1)
        if T.status(i) == 1
            %Set id to active
            M(i,T.id(i)) = 1;                 
        end
    end
end

end




