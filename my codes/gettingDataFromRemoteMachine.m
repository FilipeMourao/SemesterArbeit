function [ T ] = gettingDataFromRemoteMachine()
%% Load alarm data of specified plant
%% Input

%% Output
% T: matlab table 

    % Connect to data base
    driver = 'org.postgresql.Driver';
    url = 'jdbc:postgresql://dell-7910-165:5432/matok_grob';
    %url = 'jdbc:postgresql://192.168.5.190:5432/matok_grob';
    %url = 'jdbc:postgresql://DELL-7910-165:5432/matok_grob';
    conn = database('matok_grob','student_grob','ge}zb}{i.V',driver,url);
    conn.Message
    % Generate table from data base
    
    sql = 'select * from matok_grob.public.alarmdaten_g5501071';
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

