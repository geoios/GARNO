function [X,LTStart,LTEnd,T] = ReceiveRoses(MP,H,DT,HT)
%% 数据读取
X0=MP(1:2);AA=MP(3);K=MP(4);w=MP(5);a=MP(6);T=MP(7);TStart=MP(8);TEnd=MP(9);alpha=MP(10);
% 中心坐标X0，包络半径AA，形状参数K，角速度w，角加速度a，间隔时间T，初始时间TStart，结束时间TEnd，偏转角度alpha
LTStart = TStart + DT;LTEnd = TEnd + DT;
%% DT+HT后坐标生成
b = 0;
c = 0;
number = (TEnd - TStart) / T;
if nargin<4||isempty(HT)
    DT = DT * ones(floor(number),1);
    HT = 0;
end
for k=1:1:number + 1 + abs(fix(max((DT + HT) / T)))
    t = (k - 1) * T;
    %% 加速度与时间的关系式
    A(k) = a + b * t + c * t^2;
    %----------------------%
end
W = w;
TT = (DT + HT) / T;
for k=1:1:size(DT,1)
    w = W;
    Angle = 0;
    for i=1:1:k + TT(k)
        angle = w * T + 1 / 2 * (A(i + 1) + A(i)) / 2 * T^2;
        w = w + (A(i + 1)+A(i)) / 2 * T;
        Angle = Angle + angle;
    end
    RT = (TT(k)-fix(TT(k))) * T;
    angle = w * RT + 1/2 * (A(i+1) + A(i)) / 2 * RT^2;
    theta = Angle + angle;
    
    rho = AA * cos(K * theta);
    
    [xx,yy]  = pol2cart(theta + alpha, rho); %将极坐标转换为笛卡尔坐标
    X(k,1:2) = [xx,yy] + X0;
    X(k,3)=ErrorFunction(H,(k-1)*T+TT(k)+RT);
end
end

