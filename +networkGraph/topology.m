function [U, GridX, GridY] = topology(X)
%% Calculate the topology map specifying the density of areas of X
% Lie dense mesh over X and calculate the distance between every map point
% and its closest node in X

%% Input/Output:
% X: node positions in n-dimensional space
% U: topology matrix (distance between mesh points and closest X node)
% GridX/GridY: positions of mesh points as matlab grid

%% Calculate distances between positions in P
D = networkGraph.distancematrix(X);
D(D == 0) = NaN;

%% Design the grid
stepsize = max(nanmin(D(:)) , min( max(X) - min(X))/1000 );
x = min( X(:,1) )-stepsize : stepsize : max( X(:,1) )+stepsize;
y = min( X(:,2) )-stepsize : stepsize : max( X(:,2) )+stepsize;

%% Calculate the distance from each grid point to the closest point in X
U=zeros(length(y), length(x));

for i = 1:length(x) %rows / y
    for j = 1:length(y) % columns / x 
        d = sqrt( (x(i)-X(:,1)).^2 + (y(j)-X(:,2)).^2 );
        U(j, i) = min(d);
    end
end

%% Mesh grid output
[GridX,GridY] = meshgrid(x,y);
end