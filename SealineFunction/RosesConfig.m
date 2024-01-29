function [theta rho X]=RosesConfig(a,k,delt,k1,k2)

%
%玫瑰线方程的表达如下图：
%rho=a*sin(k*theta)
%rho=a*cos(k*theta)。
%当k为整数且为奇数时，玫瑰线叶子的个数为k，周期为pi；
%当k为整数且为偶数时，玫瑰线叶子的个数为2*k，周期为2*pi；
%当k为分数（N/D），分子N分母D均为奇数时，玫瑰线叶子数为N，周期为D*pi，分子N分母D有一个为偶数时，玫瑰线叶子数为2*N，周期为2*D*pi。

if k==fix(k)
   if k/2 == fix(k/2)
    % 当k为整数且为偶数时，玫瑰线叶子的个数为2*k，周期为2*pi。以玫瑰线方程rho=10*cos(4*theta)为例绘制图像。
    theta=delt:delt:2*pi;
    rho=a*cos(k*theta);
   else
    %%%当k为整数且为奇数时，玫瑰线叶子的个数为k，周期为pi。以玫瑰线方程rho=10*cos(3*theta)为例绘制图像。
    theta=delt:delt:pi;
    rho=a*cos(k*theta);
   end
else
    if k1/2 ~= fix(k1/2)
        if k2/2 ~= fix(k2/2)
            theta=delt:delt:k2*pi;
            rho=a*cos(k*theta);
        else
            theta=delt:delt:2*k2*pi;
            rho=a*cos(k*theta);
        end
    else
        %% TODO
            theta=delt:delt:2*k2*pi;
            rho=a*cos(k*theta);
    end
end
%[theta, r]=cart2pol(x,y) %将笛卡尔坐标转换为极坐标

[x,y]=pol2cart(theta, rho); %将极坐标转换为笛卡尔坐标
X = [x' y'];