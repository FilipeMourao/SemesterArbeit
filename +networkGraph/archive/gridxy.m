function [gridx,gridy] = gridxy(X,D)

%% Creation of grid
len=length(X);
% remove zeros from Distance Matrix
for i=1:len
    for j=1:len
        if D(i,j)==0
            D(i,j)=nan;
        end
    end
end
stepsize=min(min(D))*10;
max2=max(X)+1;
min2=min(X)-1;
gridx=min2(1):stepsize:max2(1);
gridy=min2(2):stepsize:max2(2);

end