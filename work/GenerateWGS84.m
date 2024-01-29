function [outputArg1,outputArg2] = GenerateWGS84(inputArg1,inputArg2)

% 子午椭圆的长半轴
a = 6378.137*10^3;
% 子午椭圆的短半轴
b = 6356.752*10^3;
% 极半径
c = 6356.752*10^3;
% 子午椭圆的扁率
alpha = 1/298.2572;
% 子午椭圆的第一偏心率
e = sqrt(a^2-b^2)/a;

[X,Y,Z] = ellipsoid(0,0,0,a,b,c);
surf(X,Y,Z);


end

