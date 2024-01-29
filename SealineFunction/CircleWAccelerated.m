function [ X ] = CircleWAccelerated(Circle)
% 输入参数
% X0为圆心坐标
% R为圆的半径
% w为航行中的角速度
% a为航行中的角加速度
% T为采样间隔时间
% TStart为起始时间
% TEnd为终止时间

X0=Circle.X0;R=Circle.R;w=Circle.w;a=Circle.a;T=Circle.T;
TStart=Circle.TStart;TEnd=Circle.TEnd;alpha=Circle.Alpha;
if R==0
    X=X0.*ones(max(size(TStart+T:T:TEnd)),2);
    return;
end
b=0;
c=0;
number=(TEnd-TStart)/T;

for k=1:1:number+1
    t=(k-1)*T;
    %% 加速度与时间的关系式
    A(k)=a+b*t+c*t^2;
    %----------------------%
end

Angle(1)=alpha;
j=0;
for i=1:1:number
    angle=w*T+1/2*(A(i+1)+A(i))/2*T^2;
    w=w+(A(i+1)+A(i))/2*T;
    Angle(i+1)=Angle(i)+angle;
    j=j+1;
    theta(j)=Angle(i+1);
end

x=R*cos(theta)+X0(1,1);
y=R*sin(theta)+X0(1,2);

X=[x' y'];

end

