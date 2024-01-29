function [ X ] = SegmentVAccelerated( Segment )
% 线段初始点坐标 x0
% 观测速度 v
% 观测角速度 a
% 观测间隔时间 T
% TStart为起始时间 
% TEnd为终止时间 
% 线段方位角 alpha
x0=Segment.X0;v=Segment.v;a=Segment.a;T=Segment.T;
TStart=Segment.TStart;TEnd=Segment.TEnd;alpha=Segment.Alpha;
b=0;
c=0;
number=(TEnd-TStart)/T;
for k=1:1:number+1
    t=(k-1)*T;
    %% 加速度与时间的关系式
    A(k)=a+b*t+c*t^2;
    %----------------------%
end
S(1)=0;
j=0;
for i=1:1:number
    s=v*T+1/2*(A(i+1)+A(i))/2*T^2;
    v=v+(A(i+1)+A(i))/2*T;
    S(i+1)=S(i)+s;
    j=j+1;
    SS(j)=S(i+1);
end
if alpha<=90 && alpha >=0
    alpha=90-alpha;
elseif alpha>90&&alpha<270
    alpha=-(alpha-90);
else
    alpha=360-alpha+90;
end
theta=alpha*pi/180;
for j=1:1:length(SS)
    x(j,1)=x0(1,1)+SS(j)*cos(theta);
    y(j,1)=x0(1,2)+SS(j)*sin(theta);
end
X=[x,y];
end

