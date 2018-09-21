function [ output_args ] = Untitled4( input_args )

tic
counter = 0; %progress counter

filename = 'Y:\Daten\Plant2\plant2_bru.csv';

numlines = str2double(perl('countlines.pl', filename)); % get number of lines

startRow = 1; % Starting Row in csv
stepRow = 10000; % Step size 
endRow = numlines; % Last Row in csv

uniqueID = cell(1); % ID strings
last_id = 1; % Last ID number
last_i = 1; % Last row for newTable

newTable = array2table(zeros(endRow,3)); % create new table
newTable.Properties.VariableNames = {'date','id','status'}; % rename labels


for currentRow = startRow:stepRow:endRow
    
    tempTable = importfile_plant2(filename, currentRow, currentRow + stepRow - 1); % import temporary table
    
    tempTable = unique(tempTable); % only unique entries
    tempTable = sortrows(tempTable,'date'); % sort table by date
    tempTable = sortrows(tempTable,'id'); % sort table by date
    
    id = zeros(size(tempTable,1),1); % ID numbers
    
    for i = 1:1:size(tempTable,1)
        
        if currentRow + i - 1 == endRow
            break;
        elseif i==1 && currentRow == startRow % check for first call to start with ID 1
            id(i,1) = last_id;
            uniqueID{1,1} = tempTable.id{i};
            continue;  
        elseif strcmp(tempTable.id{i},uniqueID{last_id,1})== 1 % check for last_id to save time
            id(i,1) = last_id;
            continue;    
        end
    
        j = find(ismember(uniqueID, tempTable.id{i}));
        
            
            if isempty(j)==0 % compare uniqueID strings with current ID string  
                id(i,1) = j;
                last_id = j;
                break;
            else % create new ID number in case of no match
                id(i,1) = size(uniqueID,1) + 1;
                last_id = size(uniqueID,1) + 1;
                uniqueID{size(uniqueID,1)+1,1} = tempTable.id{i};
            end
    
    end
    
    new_tempTable = table(datenum(tempTable.date),id,tempTable.status); % create new temporary table
    new_tempTable.Properties.VariableNames = {'date','id','status'}; % rename labels

    newTable(last_i:last_i + i - 1,:) = new_tempTable(1:i,:); % add new_tempTable to  newTable
    last_i = last_i + i;
    
    % progress
    counter = counter + 1; 
    counter/size(startRow:stepRow:endRow,2)*100
    toc
    
    
end

newTable(newTable.date ==0,:) = []; % delete empty rows
newTable = unique(newTable); % only unique entries

end





    
   



