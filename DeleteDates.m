function [inputTable] = DeleteDates(inputTable,dates)

for i=1:size(dates,2)
    inputTable(inputTable.date ==dates(i),:) = []; % delete empty rows
end

end

