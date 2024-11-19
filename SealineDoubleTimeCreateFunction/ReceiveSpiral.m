function [X,LTStart,LTEnd,T] = ReceiveSpiral(MP,H,DT,HT)

%% 数据读取
X0=MP(1:2);r=MP(3);w=MP(4);a=MP(5);L=MP(6);
V=MP(7);A=MP(8);T=MP(9);TStart=MP(10);TEnd=MP(11);alpha=MP(12);
% 中心点坐标 x0;初始半径 r；旋转角速度 w； 旋转角加速度 a； 螺旋初始螺距 L； 
% 螺距增长初速度 V；螺距增长加速度 A；观测间隔时间 T；TStart为起始时间；TEnd为终止时间
LTStart = TStart + DT;LTEnd = TEnd + DT;
%% DT+HT后坐标生成
b=0;B=0;
c=0;C=0;
number = (TEnd - TStart)/T;
if nargin<4||isempty(HT)
    DT = DT * ones(floor(number),1);
    HT = 0;
end
for k=1:1:number + 1 + fix(max(DT + HT))
    t = (k - 1) * T;
    %% 加速度与时间的关系式
    aa(k) = a + b * t + c * t^2;  % 旋转加速度
    AA(k) = A + B * t + C * t^2;  % 螺距加速度
    %----------------------%
end

W = w;VV = V;
TT= (DT + HT)/T;
for k=1:size(DT,1)
    w = W;V = VV;Angle = alpha;S = L;
    for i=1:1:k + TT(k)
        angle = w * T + 1/2 * (aa(i+1) + aa(i)) / 2 * T^2;
        s = V * T + 1/2 * (AA(i+1) + AA(i))/ 2 * T^2;
        w = w + (aa(i+1) + aa(i))/ 2 * T;
        V = V + (AA(i+1) + AA(i))/2 * T;
        Angle = Angle + angle;
        S = S + s;
    end
    RT = (TT(k) - fix(TT(k))) * T;
    
    angle = w * RT + 1/2 * (aa(i+1) + aa(i))/2 * RT^2;
    s = V * RT + 1/2 * (AA(i+1) + AA(i))/2 * RT^2;
    Angle = Angle + angle;
    S = S + s;
    
    R = r + S * Angle/2/pi;
    [xx,yy] = pol2cart(Angle, R); %将极坐标转换为笛卡尔坐标
    X(k,1:2) = [xx,yy] + X0;
    X(k,3)=ErrorFunction(H,(k-1)*T+TT(k)+RT);
end
end

