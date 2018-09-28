function[ka,kr,kg,w,imax,state] = NetworkGraph_interface_update(h,fig,i)
%% Update NetworkGraph Interface
%
% Output:
% ka:    Attraction constant
% kr:    Repulsion constant
% kg:    Gravitation constant
% w:     Edge Weight Influence
% imax:  max. Iterations
% state: state (Start/Stop)
%
% Input:
% h:   object handle
% fig: figure handle
% i:   Iteration

 
%% Update function parameters & state
ka = str2double(h.e_ka.String);
kr = str2double(h.e_kr.String);
kg = str2double(h.e_kg.String);
w = str2double(h.e_w.String);
imax = str2double(h.e_imax.String);
state = h.b_stop.UserData;


%% Update guidata
data = guidata(fig);
data.ka = ka; 
data.kr = kr; 
data.kg = kg; 
data.w = w; 
data.imax = imax; 

guidata(fig,data) 

%% Update Interface
h.t_i.String = num2str(i);

if i==imax
    h.b_stop.String = 'Start';
    h.b_stop.UserData = 0;
    h.b_pause.Visible = 'off';
end

end