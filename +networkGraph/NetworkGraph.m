function [X,Fa,Fr,Fg] = NetworkGraph(A,ka,kr,kg,s,w,Dim,iMax,saveDir)
%% Create network graph 
%
% Output:
% P:  Position
% Fa: Attraction Force
% Fr: Repulsion Force
% Fg: Gravitational Force
%
% Input:
% A:    Adjacency matrix
% ka:   Attraction constant
% kr:   Repulsion constant
% kg:   Gravitation constant
% s:    speed
% w:    Edge Weight Influence
% imax: max. Iterations
% dim:  Dimension 
if nargin < 5
    s = 1;
end
if nargin < 6
    w = 1;
end
if nargin < 7 || isempty(Dim)
    Dim = 2;
end
if nargin < 8 || isempty(iMax)
    iMax = 10000;
end
if nargin < 9 || isempty(saveDir)
    saveDir = '';
else
    if ~exist(saveDir, 'dir')
        mkdir(saveDir);
    end
end

%% Initialize Interface
[S,fig] = networkGraph.NetworkGraph_interface(A,ka,kr,kg,w,iMax,Dim);

%% Degree Vector
Deg = sum(A>0)';
%Deg = Deg/max(Deg);

%% Random Position 
X = rand(size(A,1),Dim) - 0.5; %0.01*
%P=makesphere(P);

%% Iteration
i=1;
while (i <= iMax)
        
    %% Calculate New Position
    [Fa,Fr,Fg] = Forces(X,A,Deg,w);
      
    %% Normalize Forces [-1..1]
    Fa = Fa/max(abs(Fa(:)));
    Fr = Fr/max(abs(Fr(:)));
    Fg = Fg/max(abs(Fg(:)));
    
    %% Calculate weighted Forces
    Fa = ka*Fa;
    Fr = kr*Fr;
    Fg = kg*Fg;

    X = X + s * (Fa + Fr + Fg);
    
    %P=makesphere(P);
    
    %% Normalize Positon [0..1]    
    %P = (P - min(P))./(max(P) - min(P))-0.5;

    %% Plot
    if Dim==2
        h = scatter(X(:,1),X(:,2),10,'k','filled');
        pbaspect(h.Parent, [1,1,1]);
        drawnow
    elseif Dim==3
        h = scatter3(X(:,1),X(:,2),X(:,3),'filled');
        pbaspect(h.Parent, [1,1,1]);
        drawnow
    end
    
    %% Save plot and positions X for certain iterations
    if ~isempty(saveDir)
        if any([1, 25, 50, 100, 250, 500] == i) || mod(i, 1000) == 0
            saveCurrent(saveDir, i, X, w);
        end
    end
        
    %% Update Interface & Parameters
    [ka,kr,kg,w,iMax,state] = networkGraph.NetworkGraph_interface_update(S,fig,i);
    
    %% Check State
    if state==2 %Pause
        waitfor(S.b_stop,'UserData');
        [ka,kr,kg,w,iMax,state] = networkGraph.NetworkGraph_interface_update(S,fig,i);
    end
    if state==0 %Stop
        break;
    end
    
    
    
    i = i + 1;

end


end


function [Fa,Fr,Fg] = Forces(X,A,Deg,w)
%% Calculate Forces
%
% Output:
% Fa: Attraction Force
% Fr: Repulsion Force
% Fg: Gravitational Force
%
% Input:
% X:  Position matrix
% A:  Adjacency matrix
% Deg:  Degree vector
% ka: Attraction constant
% kr: Repulsion constant
% kg: Gravitation constant
% w:  Edge Weight Influence

%% Preallocation
n = size(X,1);      % Number of IDs
m = size(X,2);      % Number of dimension
Fa = zeros(n,m);    % Attraction force
Fr = zeros(n,m);    % Repulsion force

addDeg = 1;

for i = 1:length(X)              %for all nodes
    
    %% Calculate distances from one node to all other nodes
    D = X - X(i,:);
    
    %% Norm of each row
    Dn = rnorm(D);
       
    %% Attraction Force 
    Fa(i,:) = sum(D.*A(:,i).^w./(Deg(i)+addDeg),1);                 %Adds up the attraction forces of node i divided by the degree od the node i 
   
    %% Repulsion Force 
    Frx = -(Deg(i) + addDeg)*(Deg + addDeg).*D./Dn.^2;              %repulsion force of node i, depending on degree and distance of/to the other nodes
    Frx(D==0)=0;
   
    Fr(i,:) = sum(Frx.*~isinf(Frx),1,'omitnan');                    %Adds up the repulsion force of each node; omitnan: ignors all NaN values in the input 
        
end
   
    %% Position from center
    Dc = X - mean(X);                                               % in X- and Y-Koordinations
  
    %% Norm of each row
    Dcn = rnorm(Dc);
    
    %% Gravitational Force from center of gravity
    Fg = -(Deg + addDeg).*Dc./Dcn;   
    Fg(Dc==0)=0;

end

function h=rnorm(X)
%% Norm of each row of X
h=0;

for j=1:size(X,2)
    h=h+X(:,j).^2;
end

h=sqrt(h);
end


function X=makesphere(X)

X = X - mean(X);

r = mean(rnorm(X));

X = r*normr(X);

end

function saveCurrent(saveDir, i, X, w)
%% Save current iteration in plot, emf and mat file
%% Create a figure 
f = figure;
h = scatter(X(:,1),X(:,2),10,'k','filled');
%pbaspect(h.Parent, [1,1,1]);
drawnow

%% Save the figure
savePath = [saveDir,'/w', num2str(w) '_iter', num2str(i), ];
savefig(h.Parent.Parent, [savePath, '.fig']);
saveas(h.Parent.Parent, [savePath, '.emf']);

%% Save the current positions
save([savePath, '.mat'], 'X');

%% Close the figure 
close(f);
end