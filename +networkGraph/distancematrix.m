function [D,iSort] = distancematrix(X, k)
%% Calculate the distances between every point in X
% Input:
% X: positions in network graph (N*M)
N = size(X,1);
M = size(X,2);
% k: number of connections between x
if nargin < 2 || isempty(k)
    k = N-1;
end
% Output:
% D: n*n matrix containing distance between every point in X
% iSort: specifies, which entries in X are closest to its k neighbors

%% Create distance matrix and a vector containing the summed up distance 
% to the k nearest neighbors 
D = zeros(N);
minKDist = zeros(N,1);

for i = 1:N
    % Calculate distances to other points in X
    for j = 1:M
        D(:, i) = D(:, i) + (X(:,j) - X(i,j)).^2;
    end
    D(:, i) = sqrt(D(:, i));
    
    % Sum up k nearest distances
    d = sortrows( D(:, i) );
    minKDist(i) = sum( d(2:k+1) );
end

%% Create iSort
% Ascending order of points in X with biggest distance to k nearest
% neighbors
[~, iSort] = sortrows(minKDist);
%[D, iSort] = sortrows(minKDist);
end