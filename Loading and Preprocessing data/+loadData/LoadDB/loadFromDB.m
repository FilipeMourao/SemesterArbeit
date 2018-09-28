function [ T ] = loadFromDB(apsname)
%% Load alarm data of specified plant
%% Input
% apsname: table name of automated production system as found in 
% ALARM_ODBC_READ
%% Output
% T: matlab table 

    % Connect to data base
    conn = database('AlarmReadOrg','','');
    
    % Generate table from data base
    sql = ['SELECT * FROM ',apsname];
    ds = databaseDatastore(conn,sql);
    ds.ReadSize = 1000000;%By default, read reads from a TabularTextDatastore 20000 rows at a time. 
	%To read a different number of rows in each call to read, modify the ReadSize property of ds.
    reset(ds);
    T = read(ds);
    % Read out chunkwise
    while(hasdata(ds))
        T = [T;read(ds)];
    end
    close (ds);
    
    % Close DB-Connection
    close(conn);
end

