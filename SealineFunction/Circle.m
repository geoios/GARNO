function [ X ] = Circle( X0,R,w,a,T,TStart,TEnd )

% 输入参数
% X0为圆心坐标
% R为圆的半径
% w为航行中的角速度
% a为航行中的角加速度
% T为采样间隔时间
% TStart为起始时间
% TEnd为终止时间

b=0;
c=0;

for k=1:1:TEnd/T+1
    t=(k-1)*T;
    %% 加速度与时间的关系式
    A(k)=a+b*t+c*t^2;
    %----------------------%
end

Angle(1)=0;
j=0;
for i=1:1:TEnd/T
    angle=w*T+1/2*(A(i+1)+A(i))/2*T^2;
    w=w+(A(i+1)+A(i))/2*T;
    Angle(i+1)=Angle(i)+angle;
    if i>fix(TStart/T)
        j=j+1;
        theta(j)=Angle(i+1);
    end
end

x=R*cos(theta)+X0(1,1);
y=R*sin(theta)+X0(1,2);

X=[x' y'];

end

