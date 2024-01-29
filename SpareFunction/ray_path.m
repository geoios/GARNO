function [x,ray_length] = ray_path(t_angle,nlyr,layer_d,layer_s,sv_d,sv_s,y_d,y_s,l_dep,l_sv)
%RAY_PATH 此处显示有关此函数的摘要
%   输入参数：入射角 、声速剖面层数、应答器所在深度层、换能器所在深度层、
%   sv_d应答器所在深度的声速、sv_s换能器所在深度的声速、海底应答器坐标U方向坐标、海面换能器坐标U方向坐标、深度list、声速list
%   输出参数：水平距离 、射线路径的长度

%   Calculation for ray path 射线路径计算
x=0;ray_length=0;
% PP = sin(theta)/SV_D  该值为Snell常数
pp=sin(t_angle)/sv_d;   %pp=sin(入射角)/应答器所在位置声速

if(y_d==y_s) % 如果深度相同
    x=-1.0;
    disp("Warning A in ray_path");
    error('Warning A in ray_path');
end

% k1=海面层-1
k1=layer_s-1;
% layer for the deeper end               较深端层
lm=layer_d;

% 根据Snell指数求解每层入射角(第一层改为换能器入射角，最后一层应答器入射角)
sn(k1:layer_d)=pp*l_sv(k1:layer_d); 
% 更改深度层列表yd(第一层改为换能器深度，最后一层应答器深度)
yd(k1:layer_d)=l_dep(k1:layer_d);

yd(k1) = y_s;              % yd(k1) = 海面换能器U坐标
sn(k1) = pp*sv_s;          % sn(k1) = 海面入射角
yd(layer_d) = y_d;         % yd(layer_d) = 海底应答器U坐标
sn(layer_d) = pp*sv_d;     % sn(layer_d) = 海底应答器所在深度入射角

if max(sn(k1:layer_d)) >1.0||min(sn(k1:layer_d))<-1.0
    x=-1.0;
    error('Wraning B');
end

scn(k1:layer_d)=sqrt(1.0-sn(k1:layer_d).^2); % cos(入射角)
rn(k1:layer_d-1)=scn(lm)./scn(k1:layer_d-1); % rn=cos(应答器theta)/cos(每层theta)
rn(layer_d)=1.0;

for i=layer_s:layer_d
    j=i-1;
    dx=(yd(i)-yd(j))*(sn(i)+sn(j))/(scn(i)+scn(j));
    x=x+dx;
    ray_length=ray_length+rn(i)*dx/scn(j);
end
ray_length=ray_length/sn(lm);


end

