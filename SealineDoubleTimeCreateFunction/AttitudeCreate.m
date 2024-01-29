function [ beta ] = AttitudeCreate( Angle,AngleAdd)
%% 对heading的生成修改
% 生成一个0.0001s以后的坐标，对这两个求取斜率即为heading
for i=1:size(Angle,1)
    if Angle(i,2) == AngleAdd(i,2)
        if Angle(i,1)<AngleAdd(i,1)
            beta(i)=pi/2;
        elseif Angle(i,1)>AngleAdd(i,1)
            beta(i)=3*pi/2;
        else
            beta(i)=0;
        end
    elseif Angle(i,2)<AngleAdd(i,2)
        if Angle(i,1)<=AngleAdd(i,1)
            beta(i)=atan((AngleAdd(i,1)-Angle(i,1))/(AngleAdd(i,2)-Angle(i,2)));
        else
            beta(i)=atan((AngleAdd(i,1)-Angle(i,1))/(AngleAdd(i,2)-Angle(i,2)))+2*pi;
        end
    else
        beta(i)=atan((AngleAdd(i,1)-Angle(i,1))/(AngleAdd(i,2)-Angle(i,2)))+pi;
    end
    beta(i)=beta(i)*180/pi;
end
beta=beta';

end

