function [soundVelocity] = inverseEofFun(timeSpaceCoordinate,Eof)
%% 函数说明
%变量解释：
%函数功能：给定（x,y,t）输出声速

%% 参数传递
t=timeSpaceCoordinate(1);
x=timeSpaceCoordinate(2);
y=timeSpaceCoordinate(3);
order = 6;

%% 拟合6阶pc
B = [1 x y t];
fitPc = zeros(order,1);
for iPc=1:order
    fitPc(iPc,1) = B * Eof.fitPcCoefficient(:,iPc);
end

%% 重构
soundVelocity = Eof.averageDataMatrix(:,1) + Eof.f(:,1:order) * fitPc;
end

