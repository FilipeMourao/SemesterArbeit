function [normA, A] = frequencymatrix(id, t)
%% Creates a frequency matrix of id, sorted by t
% Frequenzy matrix describes, how often alarm A directly follows alarm B in
% the data

%% Input:
% id: vector with N different alarm IDs, only containing coming alarms
% t: time point of occurance of each element in id

%% Sort id according to t
[~, iSort] = sortrows(t);
id = id(iSort);

%% Create frequency matrix
[U, ~, iu] = unique(id);    % U: set of unique IDs
                            % iu: position of unique IDs in id
N = length(U);  % Number of different IDs

A = zeros(N, N);
parfor i = 1 : N
    for j = 1 : N
        % Count how often alarm j  directly follows alarm i
        A(i, j) = frequencypair(iu, U(i), U(j));
    end
end

%% Normalize A row wise
normA = zeros(N, N);
sumA = sum(A, 2);
parfor i = 1:N
    normA(i,:) = A(i,:) / sumA(i);
end
end

function a = frequencypair(iu, i, j)
%% Calculate, how often alarm j directly follows alarm i in iu
if i ~= j
    iBool = (iu == i);
    jBool = (iu == j);
    a = sum( iBool(1:end-1) & jBool(2:end) );
else
    a = 0;
end
end