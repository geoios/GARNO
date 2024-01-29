function [ X ] = SeafloorPolygonPoints(MP,h)
%% 数据读取
x0 = MP(1:2);S = MP(3);R = MP(4);alpha = MP(5);
%多边形中心坐标 x0；多边形的边数 S；多边形外接圆半径 R；多边形旋转角度 alpha；
%% 坐标点生成
theta=linspace(alpha,alpha+2*pi,S+1);
X = [R*cos(theta'),R*sin(theta')] + x0;
X=X(1:S,:);

X(:,3)=ErrorFunction(h,0:S-1);
end

