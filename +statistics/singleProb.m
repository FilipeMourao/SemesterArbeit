function [p] = singlePro(time,active,inactive)
%% Calculate single probability
%
% Input
% time: date vector
% Matrix active:   entry 1 when alarm gets active 
% Matrix inactive: entry 1 when alarm gets inactive
%
% Output
% Array p with probability for each id

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%

% Preallocate size
p = zeros(1,size(active,2));

for i = 1:size(active,2)
    
    % Rows when alarm is 0,1
    r0 = logical(inactive(:,i));
    r1 = logical(active(:,i));
    
    % If alarm doesnt get inactive in the end
    if sum(r1) > sum(r0)
        r0(end)=1;
    end
    
    % Calculate Probability
    p(1,i) = sum(time(r0) - time(r1))/(time(end)-time(1));
    
end

end

