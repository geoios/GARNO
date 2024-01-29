% function [T,Y,Z,L,theta,Iteration,RayInf] = P2PInvRayTrace(PF,S,R,Data,Control,Par)

function [T,Y,Z,L,theta,Iteration,RayInf] = P2PInvRayTrace(S,R,Data)
[Control,Par] = RayTracing_ControlSystem(); % 入射角、结算方法、基本参数配置InDirect、Tangent
PF = Data.PF;

% ts,xx,zz,LL,
% P2PInvRayTracing(PF,S,R,tag,tag1)
%% P2PInvRayTracing(DataOfPoumian,S,R)->tracing of two 3-D points 两个三维点的追踪
 %% inputs: 输入
  % + PF     %   Sound profile   声速剖面
  % + S      %   location of the source  海面换能器的位置
  % + R      %   Location of receiver  海底应答器位置
 %% outputs
  % +   %
 %% Remarks  评论
   % + The depth coordinates of the profile are based on the instantaneous 剖面的深度坐标基于瞬时坐标
   %   sea level, and take the downward direction as positive 海平面，向下方向为正
   % + The coordinates of the surface or seafloor points may be based on 表面或海底点的坐标可基于
   %   the local coordinate system, thus the depth is based on the ellipsoid surface, 局部坐标系，因此深度基于椭球面，
   %   and take the downward direction as negtive 将向下的方向作为负方向
 %% Control
   % Direct    %%   直接
   % InDirect  %%   间接
 %%
% 由于声速剖面是基于海平面瞬时坐标系向下方向为正；但由于海面点都是局部坐标系向下为负方向
% 因此将局部坐标系下的负方向->(+) | 同时考虑声源从海底点发射则交换两坐标
[S,R] = PreProcessingPoints(S,R);

% for sound ray tracing 用于声线跟踪

Horizontal      = norm(S(1:2) - R(1:2));    % 水平距离
Depth           = R(3) - S(3);              % 高程距离
Data.RH=R(3);Data.SH=S(3);
if isfield(Control,'Direct') 
    Grid         = Data.ExtendLayer(:,2:3);
    WindowWidth  = Par.WindowWidth;
    FittingOrder = Par.FittingOrder;
    [T,SigmaY] = DelayTimeInterpolation(Horizontal,Grid,WindowWidth,FittingOrder);  
    Y = SigmaY;
    TimeEstimation;
elseif isfield(Control,'InDirect') 
    Control = Control.InDirect;
    % In most cases, the tracing is not started from the sea surface 在大多数情况下，追踪不是从海面开始的
    if S(3) > 0
        PF = SplitProfile(PF,S(3),PF(end,1)); 
    end
    [T,Y,Z,L,theta,Iteration,RayInf] = InvRayTrace(PF,+inf,Horizontal,Depth,Data,Control,Par);  
else
    disp('Control is undefined')
    return
end

end
%% 3D recovery
% Z  = Z  + S(3);
% zz = zz + S(3);
% XX = ei(1) * Horizontal;
% YY = ei(2) * Horizontal;