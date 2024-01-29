function [ X ] = Spiral( X0,r,w,a,L,V,A,T,TStart,TEnd )
% 中心点坐标 x0
% 初始半径 r.
% 旋转角速度 w
% 旋转角加速度 a
% 螺旋初始螺距 L
% 螺距增长初速度 V
% 螺距增长加速度 A
% 观测间隔时间 T
% TStart为起始时间
% TEnd为终止时间

b=0;B=0;
c=0;C=0;
for k=1:1:TEnd/T+1
    t=(k-1)*T;
    %% 加速度与时间的关系式
    aa(k)=a+b*t+c*t^2;  % 旋转加速度
    AA(k)=A+B*t+C*t^2;  % 螺距加速度
    %----------------------%
end

Angle(1)=0;
S(1)=L;
j=0;
for i=1:1:TEnd/T
    angle=w*T+1/2*(aa(i+1)+aa(i))/2*T^2;
    s=V*T+1/2*(AA(i+1)+AA(i))/2*T^2;
    w=w+(aa(i+1)+aa(i))/2*T;
    AC=V+(AA(i+1)+AA(i))/2*T;
    Angle(i+1)=Angle(i)+angle;
    S(i+1)=S(i)+s;
    if i>fix(TStart/T)
        j=j+1;
        theta(j)=Angle(i+1);
        R(j)=r+S(i+1)*theta(j);
    end
end
[x,y]=pol2cart(theta, R); %将极坐标转换为笛卡尔坐标
x=x+X0(1,1);
y=y+X0(1,2);
X = [x' y'];

end

