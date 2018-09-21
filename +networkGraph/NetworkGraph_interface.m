function [h,fig] = NetworkGraph_interface(A,ka,kr,kg,w,imax,dim)
%% Create ForceAtlas2 Interface
%
% Output
% h:   object handles
% fig: figure handle
%
% Input:
% A:    Adjacency matrix
% ka:   Attraction constant
% kr:   Repulsion constant
% kg:   Gravitation constant
% w:    Edge Weight Influence
% imax: max. Iterations
% dim:  Dimension


%% Set Figure handle
ho = gcbo;
if isempty(ho)
    fig = figure;    
elseif strcmp(ho.String,'Stop')
    data = guidata(ho);
    fig = data.fig;
end


%% Set Objects

% State button
h.b_stop = uicontrol('Parent',fig,'Style','pushbutton','String','Stop','UserData',1,'Units','normalized','Position',[0.01 0.45 0.1 0.05]);
h.b_pause = uicontrol('Parent',fig,'Style','pushbutton','String','Pause','UserData',1,'Units','normalized','Position',[0.01 0.5 0.1 0.05]);

% Parameter texts
uicontrol('Parent',fig,'Style','edit','String','ka','Units','normalized','Position',[0.01 0.94 0.05 0.05],'Enable','inactive','BackgroundColor',[0.7 0.7 0.7]);
uicontrol('Parent',fig,'Style','edit','String','kr','Units','normalized','Position',[0.01 0.88 0.05 0.05],'Enable','inactive','BackgroundColor',[0.7 0.7 0.7]);
uicontrol('Parent',fig,'Style','edit','String','kg','Units','normalized','Position',[0.01 0.82 0.05 0.05],'Enable','inactive','BackgroundColor',[0.7 0.7 0.7]);
uicontrol('Parent',fig,'Style','edit','String','w','Units','normalized','Position',[0.01 0.76 0.05 0.05],'Enable','inactive','BackgroundColor',[0.7 0.7 0.7]);
uicontrol('Parent',fig,'Style','edit','String','imax','Units','normalized','Position',[0.01 0.70 0.05 0.05],'Enable','inactive','BackgroundColor',[0.7 0.7 0.7]);
uicontrol('Parent',fig,'Style','edit','String','i','Units','normalized','Position',[0.01 0.6 0.05 0.05],'Enable','inactive','BackgroundColor',[0.7 0.7 0.7]);
h.t_i = uicontrol('Parent',fig,'Style','edit','String','0','Units','normalized','Position',[0.06 0.6 0.05 0.05],'Enable','inactive','BackgroundColor',[0.7 0.7 0.7]);

% Parameter edits
h.e_ka = uicontrol('Parent',fig,'Style','edit','String',ka,'Units','normalized','Position',[0.06 0.94 0.05 0.05]);
h.e_kr = uicontrol('Parent',fig,'Style','edit','String',kr,'Units','normalized','Position',[0.06 0.88 0.05 0.05]);
h.e_kg = uicontrol('Parent',fig,'Style','edit','String',kg,'Units','normalized','Position',[0.06 0.82 0.05 0.05]);
h.e_w =  uicontrol('Parent',fig,'Style','edit','String',w,'Units','normalized','Position',[0.06 0.76 0.05 0.05]);
h.e_imax =  uicontrol('Parent',fig,'Style','edit','String',imax,'Units','normalized','Position',[0.06 0.70 0.05 0.05]);

%% set guidata
data.fig = fig;
data.h = h;
data.A = A; 
data.dim = dim;
guidata(fig,data);

%% Set Callbacks
set(h.b_stop,'Callback',@Callback_b_stop);
set(h.b_pause,'Callback',@Callback_b_pause);

end


function Callback_b_stop(h,~)

%% Get Gui data
data = guidata(gcbo);
if strcmp(h.String,'Start')
    h.UserData = 1;
    h.String = 'Stop';
    data.h.b_pause.Visible = 'on';
    
    %% Update Parameter
    networkGraph.NetworkGraph_interface_update(data.h,data.fig,0);
    data = guidata(gcbo);
    
    %% Rerun ForceAtlas2
    networkGraph.NetworkGraph(data.A,data.ka,data.kr,data.kg,data.w,data.imax,data.dim);
else
    h.String = 'Start';
    data.h.b_pause.Visible = 'off';
    h.UserData = 0;
end

end


function Callback_b_pause(h,~)
%% Get Gui Data
data = guidata(gcbo);

if strcmp(h.String,'Continue')
    h.String = 'Pause';
    data.h.b_stop.UserData = 1;
else
    h.String = 'Continue';
    data.h.b_stop.UserData = 2;
end

end