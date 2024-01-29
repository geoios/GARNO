function [ X ] = Segment( x0,L,alpha,v,a,T,TStart,TEnd )
% 线段初始点坐标 x0
% 线段长度 L
% 线段方位角 alpha
% 观测速度 v
% 观测角速度 a
% 观测间隔时间 T
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

S(1)=0;
j=0;
for i=1:1:TEnd/T
    s=v*T+1/2*(A(i+1)+A(i))/2*T^2;
    v=v+(A(i+1)+A(i))/2*T;
    S(i+1)=S(i)+s;
    if i>fix(TStart/T)
        j=j+1;
        SS(j)=S(i+1);
    end
end

if alpha<=90 && alpha >=0
    alpha=90-alpha;
elseif alpha>90&&alpha<270
    alpha=-(alpha-90);
else
    alpha=360-alpha+90;
end
alpha=degtorad(alpha);

for j=1:1:length(SS)
    x(j,1)=x0(1,1)+SS(j)*cos(alpha);
    y(j,1)=x0(1,2)+SS(j)*sin(alpha);
end
x00=x0(1,1)+L*cos(alpha);
y00=x0(1,2)+L*sin(alpha);
X00=[x00,y00];
X=[x,y];
end

