function [Control,Par] = RayTracing_ControlSystem() 
%% 解算控制
% 入射角：拟合 ———> 推估
Control.InDirect = '';
Control.InDirect.Interpolation = '';
% 割线法求解初始入射角
Control.InDirect.Tangent = '';
Control.InDirect.HeightAngle = '';

%% 参数控制
% 计算入射角方法参数配置
Par.InAngle.WindowNum = 7;
Par.InAngle.Order     = 5;
Par.InAngle.TermIter  = 20;
Par.InAngle.delta     = 10^-4;


end