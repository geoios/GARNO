function [X,LTStart,LTEnd,T] = ReceiveSegment(MP,H,DT,HT)
%% 数据读取
X0=MP(1:2);v=MP(3);a=MP(4);T=MP(5);TStart=MP(6);TEnd=MP(7);alpha=MP(8);
% 中心点坐标X0；速度v；角加速度a；采样间隔时间T；初始时刻TStart；结束时刻TEnd；旋转角度 alpha
LTStart = TStart + DT;LTEnd = TEnd + DT;
%% DT+HT后坐标生成
b=0;
c=0;
number=(TEnd-TStart)/T;
if nargin<4||isempty(HT)
    DT = DT * ones(floor(number),1);
    HT = 0;
end
for k=1:1:number + 1 + fix(max( DT + HT))
    t = (k - 1) * T;
    %% 加速度与时间的关系式
    A(k) = a + b * t + c * t^2;
    %----------------------%
end
V=v;
TT=(DT+HT)/T;
for k=1:max(size(DT))
    v=V;S=0;Alpha=alpha;
    for i=1:1:(k-1)+TT(k)
        s = v * T + 1/2 * (A(i + 1) + A(i)) / 2 * T^2;
        v = v + (A(i + 1) + A(i)) / 2 * T;
        S = S + s;
    end
    if isempty(i)
       i=1;
    end
    RT = (TT(k) - fix(TT(k))) * T;
    s = v * RT + 1/2 * (A(i+1) + A(i))/2 * RT^2;
    S = S + s;
    if Alpha <= 90 && Alpha >=0
        Alpha = 90 - Alpha;
    elseif Alpha > 90 && Alpha < 270
        Alpha = -(Alpha - 90);
    else
        Alpha = 360 - Alpha + 90;
    end
    
    theta=deg2rad(Alpha);
    
    X(k,1:2)=X0+[S*cos(theta),S*sin(theta)];
    X(k,3)=ErrorFunction(H,(k-1)*T+TT(k)+RT);
end
end

