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
    sql=['SELECT * FROM ',apsname];
    ds=databaseDatastore(conn,sql);
    ds.ReadSize=1000000;
    reset(ds);
    T=read(ds);
    % Read out chunkwise
    while(hasdata(ds))
        T = [T;read(ds)];
    end
    close (ds);
    
    % Close DB-Connection
    close(conn);
end

