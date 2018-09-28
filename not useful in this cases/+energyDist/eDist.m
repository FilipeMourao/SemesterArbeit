%What is the energy distance?
function [H,A,B] = eDist(T)

%% Calculate Energy Distance
% Input
% Table T containing 'date','id','status'
% date: datenum
% id: num
% status: num
%
% Output
% H: matrix with energy distances
% A,B: Matrices to calculate H

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate matrix (column: id, row: timestep) with entry 1 when alarm is activated
ActiveIDs_mat = activeIDs.createMatrix(T,1);

% Sort table by id
T = sortrows(T,'id');
% Sort table by date
T = sortrows(T,'date');

% Size preallocation
A = zeros(size(ActiveIDs_mat,2),size(ActiveIDs_mat,2)); 
B=A;

for i_col = 1:size(ActiveIDs_mat,2)
    
    % Rows with 1 as entry
    i_row = ActiveIDs_mat(:,i_col)==1;   
    % Calculate Energy Distance
    B(i_col,:) = arithmeticAvg(T.date(i_row),T.date(i_row));
    
    for j_col = 1:i_col       
        % Calculate Energy Distance
        A(i_col,j_col) = arithmeticAvg(T.date(i_row),T.date(ActiveIDs_mat(:,j_col)==1));                           
    end
       
end
A=A+A'-eye(size(A)).*A; % Symetric matrix 
H = (2.*A-B-B')./(2.*A);

end

function [Z] = arithmeticAvg(X,Y)

%% Calculate Arithmetic averages of distances
% Input
% X,Y containing time of alarms 
%
% Output
% Z Arithmetic averages between X and Y

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Size preallocation
S = zeros(length(X),1); 

for xi = 1:length(X)   
    for yi = 1:length(Y)       
       % Distance
       S(xi,yi) = abs(X(xi) - Y(yi));          
    end    
end

% Arithmetic averages of distances
Z = sum(sum(S))/(length(X)*length(Y)); 


end

