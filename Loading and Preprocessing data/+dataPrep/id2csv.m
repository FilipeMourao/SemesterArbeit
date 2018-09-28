function csvText = id2csv(S, id, name, t, delimiter, strName, strDate)
%% Write the found sequences to a csv text
% Final csv file in excel should look as follows:
%   1 | Sequence 1  |       |       | ...
%   2 | strName:    | name1 | name2 | ...
%   3 | strDate:    | date1 | date2 | ...
%   4 | strDate:    | date2 | date2 | ...
%                   ...
%  ...| Sequence 2  |       |       | ...
% 
% Input:
% S: found sequences as matrix. rows: sequences columns: alarms (as ID, 
% only consider IDs > 0)
% id, name, t: id matches the IDs of S to their original names and dates 
% delimiter: csv delimiter to seperate entries
if nargin < 5 || isempty(delimiter)
    delimiter = ';';
end
% strName: name of the row containing names
if nargin < 6 || isempty(strName)
    strName = 'Name';
end
% strDate: name of the row containing the dates
if nargin < 7 || isempty(strDate)
    strDate = 'Date';
end

%% Start writing the text
csvText = '';
for i = 1:size(S,1)
    
    % Find the starting positions of S(i) in id
    s = S(i, S(i,:)>0);
    n = length(s);
    iS = strfind(id', s);
    
    if ~isempty(iS)
        % Header
        csvText = [csvText, 'Sequence ', num2str(i), newline];

        % delete the respective lines from id, name and t
        deleteLines = false(size(id));

        % Write the sequence names to the csv file, seperated with the
        % delimiter
        csvText = [csvText, strName];
        for j = 0:n-1
            csvText = [csvText, delimiter, name{iS(1) + j}];
        end
        % new line
        csvText = [csvText, newline];

        % Write the sequence dates to the csv text
        % Also: mark each date as used (deleteLines = true)
        for j = 1:length(iS)
            csvText = [csvText, strDate];
            for k = 0:n-1
                csvText = [csvText, delimiter, t{iS(j) + k}];
                deleteLines(iS(j) + n) = true;
            end
            csvText = [csvText, newline];
        end

        % Delete the written entries from id, name and t
        id = id(~deleteLines);
        t = t(~deleteLines);
        name = name(~deleteLines);

        % Add line break
        csvText = [csvText, newline];
    end
end
end