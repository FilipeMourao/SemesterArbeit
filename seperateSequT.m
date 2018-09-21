function T2=seperateSequT(T,tbDates)
%% Create table only containing sequences seperated on Fullen approach
% Seperate sequences with unique ID (higher than maxID)
% Input:
% T: original table
% tbDates: time based seperation dates
% Output:
% T2: table only containing Fullen sequences, seperated with xxx comment
% and unique ID
%% Find maximum ID in T1
maxID = max(T.id);
%% Create first draft of T2
% Get height of T2 similar to non-0 entries of tbDates + number of found
% sequences (seperating rows)
T2=[ T( 1:sum(tbDates(:)>0) , : ) ; T( 1:size(tbDates,1) , : )];
%% Fill T2
iRowT2=0;
for i=1:size(tbDates,1)
    % Get length of sub-sequence
    lSequ=sum( tbDates(i,:) > 0 );
    % Find position of sub-sequence in T
    iRowT = strfind( T.date' , tbDates( i, tbDates( i, 1:lSequ )>0 ) );
    % Write all entries to T2
    T2( iRowT2+1 : iRowT2+lSequ , : )=T( iRowT : iRowT+lSequ-1 , : );
    % Write seperating line
    T2( iRowT2+lSequ+1 , : )=T2( iRowT2+lSequ , : );
    T2.TagName{ iRowT2+lSequ+1 } = ['xxx-',num2str(i),'-xxx'];
    T2.id( iRowT2+lSequ+1 ) = maxID+i;
    % Increase iRowT2
    iRowT2 = iRowT2+lSequ+1;
end
end