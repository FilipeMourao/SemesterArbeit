function [P2, gridxy] = discretization(P, scalingfactor)
%% Input: Point Matrix
%% Output: Point Matrix with real positive integer values
%% Creation of the grid
min2=min(P);
max2=max(P);
X=round((10+(max2(1)-min2(1)))*scalingfactor); 
%10+ because otherwise there might be an overshoot
Y=round((10+(max2(2)-min2(2)))*scalingfactor);

% set new coordinate system origin
P2(:,1)=round((P(:,1)-min2(1)+10)*scalingfactor);
P2(:,2)=round((P(:,2)-min2(2)+10)*scalingfactor);
gridxy=zeros(X,Y);