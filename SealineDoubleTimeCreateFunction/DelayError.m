function [dL,c,SinEs] = DelayError(PF,v,Depth,IncidentAngle)
DataNum = size(IncidentAngle,1);
for i = 1:DataNum
    Theta = IncidentAngle(i) * (pi/180);
    [T,Y,Z,L] = RayTracing(PF,Theta,+inf,+inf,Depth);
    Distance = sqrt(Y^2 + Z^2);
    dL(i,:) = v * T - Distance;
    c(i)  = Distance/T;
    
    % 增加高度角计算
    SinEs(i,:) = Z/L;
    
    
end

end


