function [ sequences, occurences ] = lengthBasedSequ( data, w_length )
%FINDSEQUENCES Summary of this function goes here
%   Detailed explanation goes here
    if size(data,2)==1
        data = data(data~=0)';
    else
        data = data(data~=0);
    end
    if w_length<=length(data)
        sequences(1,:)  = data(1:w_length);
        occurences(1,1) = 1;
        i=1;
        while (i < (length(data)-w_length))
            i=i+1;
            if isnan(data(i + w_length - 1))
                i= i + w_length - 1;
            else
                tmp = (sequences == data(i:w_length+i-1));
                if (~all(tmp,2))
                    sequences(end+1,:)  = data(i:w_length+i-1);
                    occurences(end+1,1) = 1;
                else
                    occurences(all(tmp,2),1) = occurences(all(tmp,2),1) + 1;
                end
            end 
        end
        % Sort output
        [~,iSort]=sortrows(occurences,-1);
        occurences=occurences(iSort);
        sequences=sequences(iSort,:);
    else
        sequences=[];
        occurences=[];
    end
    
end

