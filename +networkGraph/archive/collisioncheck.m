function [gridxy, occupied] = collisioncheck(gridxy,startc,goalc,typ)
%% Input: gridxy:=Grid startc:=point goalc:=neighborpoint
%% Output typ==0 (Collision Check): is connection possible?
xdist=goalc(1)-startc(1);
ydist=goalc(2)-startc(2);
distance=round(sqrt(xdist^2+ydist^2));
% Normalize distances
xdist=xdist/distance;
ydist=ydist/distance;
occupied=0;

if typ==0 && occupied~=1
    for i=1:distance
        if gridxy(startc(1)+round(i*xdist),startc(2)+round(i*ydist))==1
            occupied = 1;
        end
    end
end
%% Output typ==1 (Create Obstacle): create connection
if typ==1
    for i=2:distance-1 %save space so that other nodes may connect
        if i==2 | i==distance-1
            gridxy(startc(1)+round(i*xdist),startc(2)+round(i*ydist))=1;
        else gridxy(startc(1)+round(i*xdist),startc(2)+round((i-1)*ydist))=1;
            gridxy(startc(1)+round((i-1)*xdist),startc(2)+round(i*ydist))=1;
        end
    end
end
