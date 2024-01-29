function [dL c] = DelayError(PF,v,Depth,IncidentAngle)
DataNum = size(IncidentAngle,1);
for i = 1:DataNum
    Theta = IncidentAngle(i) * (pi/180);
    [T,Y,Z,L] = RayTracing(PF,Theta,+inf,+inf,Depth);
    Distance = sqrt(Y^2 + Z^2);
    dL(i) = v * T - Distance;
    c(i)  = Distance/T;
end
end
