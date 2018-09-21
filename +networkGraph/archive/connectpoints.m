function [C,D] = connectpoints(X, n)
%% Connect neighboring vectors specified in X 
% Input:
% X: positions in network graph
% n: number of connections every point in X should try to create to other
% points
% Output:
% C: binary matrix specifying which points in X are connected

%% Calculate distances between points in X
% and get the ascending order of points in X with biggest distance to k nearest
% neighbors
[D, iDistAsc] = networkGraph.distancematrix(X,n);

%% Discretization of the grid
scalingfactor = 10;
[X2,gridxy] = networkGraph.discretization(X, scalingfactor);

%% Create C
C = false(size(X,1), size(X,1));
%% Connect points in X
% Starting with the point in X with the closest distance to its n neighbors
for i=iDistAsc'
    % Get the points in X which are closest to point i from distance matrix
    [~, neighbors] = sortrows( D(:, i) );
    neighbors( neighbors==i ) = []; % Don't connect point to itself
    
    % Set the starting point in discretized X
    xstart=X2(i,1);
    ystart=X2(i,2);
    
    nTemp = n;
    count=0; 
    j=1;
    
    while count < nTemp+1 && j < 40 %abort if n connections are created or already 39 nodes were considered (avoidance of long conncetions)
    [gridxy, occupied] = networkGraph.collisioncheck(gridxy,[xstart ystart],[X2(neighbors(j),1) X2(neighbors(j),2)],0);
        if occupied == 0
            % Create connection
            C(i,neighbors(j))=true;
            C(neighbors(j),i)=true;
            [gridxy, occupied] = networkGraph.collisioncheck(gridxy,[xstart ystart],[X2(neighbors(j),1) X2(neighbors(j),2)],1);
            count=count+1;
        else
            nTemp = nTemp+1;
        end
        j=j+1;
    end 
end 
end