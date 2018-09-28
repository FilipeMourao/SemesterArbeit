function [ sLower,oLower,index ] = bottomUpTest( data, w_length_start, occ_Threshold)
%BOTTOMUPTEST Summary of this function goes here
%   Detailed explanation goes here
    
    if (nargin < 3)
        occ_Threshold = 5;
    end


    [sLower.(['l' num2str(w_length_start)]), oLower.(['l' num2str(w_length_start)])] = helper.lengthBasedSequ(data,w_length_start);
    i = w_length_start - 1;
    
    while (i > 2)
        [s,o] = helper.lengthBasedSequ(data,i);     % Find sequences one level above
        s(o<occ_Threshold,:) = [];                  % Filter out less frequent
        for (j = 1:size(sLower.(['l' num2str(i+1)]),1))    % Loop through
            tmp = sLower.(['l' num2str(i+1)])(j,:);
            for (k = 1:size(s,1))
                found = (sum(ismember(s(k,:),tmp)) == i);
                if (found)
                    index.(['l' (i-1)]) = [i, k];
                end
            end
        end
        if (~isempty(s))
            sLower.(['l' num2str(i)]) = s;
            oLower.(['l' num2str(i)]) = o;
        end
        
        i = i - 1;
    end
end

