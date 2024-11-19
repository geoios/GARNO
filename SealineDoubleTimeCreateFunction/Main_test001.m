    close all; clear all; clc

%% 生成海底正多边形
% 正多边形参数
% x0=[0,0];           %% 多边形中心坐标
% SS=3;               %% 多边形的边数
% R=1000;             %% 多边形外接圆半径
% alpha=pi/2;         %% 多边形旋转弧度
P=[0,0,3,1000,pi/2
   0,0,4,1000,pi/2];
% 生成正多边形点位函数
for J=1:size(P,1)
x0(1,1)=P(J,1);x0(1,2)=P(J,2);SS=P(J,3);R=P(J,4);alpha=P(J,5);
[ x ] = SeafloorPolygonPoints( x0,SS,R,alpha );
% 中心布点，将中心点布置为第一点
x=[x0;x];
% 确定点位高程
n=size(x,1);
h=4000;
x(1,3)=h;
x(2:n,3)=h+linspace(-100,100,n-1)';
Data(J).x=x;
end

%% 生成轨迹坐标
% 轨迹圆
% X0=[0,0];R=h;w=pi/1800;a=0;T=1;
% TStart=0;TEnd=30*24*60*60;
C=[0,0,h,pi/1800,0,1,0,15*24*60*60
   0,0,h,pi/1800,0,1,0,30*24*60*60];
%%%  1秒采样率，完成整个图形，即1小时完成观测
for J=1:size(C,1)
X0(1,1)=C(J,1);X0(1,2)=C(J,2);R=C(J,3);w=C(J,4);
a=C(J,5);T=C(J,6);TStart=C(J,7);TEnd=C(J,8);
[ XCircle ] = Circle( X0,R,w,a,T,TStart,TEnd );
XCircle(:,3) = 0;
Data(J).XCircle=XCircle;
Data(J).TStart=TStart;
Data(J).TEnd=TEnd;
end

% % 轨迹玫瑰
% % X0=[0,0];A=2.5*h;K=4;w=pi/1800;a=0;
% % T=1;TStart=0;TEnd=10*24*60*60;
% R=[0,0,2.5*h,4,pi/1800,0,1,0,15*24*60*60
%    0,0,2.5*h,4,pi/1800,0,1,0,30*24*60*60];
% %%%  1秒采样率，完成整个图形，即1小时完成观测
% for J=1:size(R,1)
% X0(1,1)=R(J,1);X0(1,2)=R(J,2);A=R(J,3);K=R(J,4);
% w=R(J,5);a=R(J,6);T=R(J,7);TStart=R(J,8);TEnd=R(J,9);
% [ XRoses ] = Roses( X0,A,K,w,a,T,TStart,TEnd );
% XRoses(:,3) = 0;
% Data(J).XRoses=XRoses;
% Data(J).TStart=TStart;
% Data(J).TEnd=TEnd;
% end

% % 轨迹螺旋
% % X0=[0,0];r=h-2*pi*5*50;w=pi/1800;a=0;L=50;
% % V=0;A=0;T=1;TStart=0;TEnd=10*24*60*60;
% S=[0,0,h-2*pi*7.5*50,pi/1800,0,50,0,0,1,0,15*24*60*60
%    0,0,h-2*pi*15*50,pi/1800,0,50,0,0,1,0,30*24*60*60];
% % %%%  1秒采样率，完成整个图形，即1小时完成观测
% for J=1:size(S,1)
% X0(1,1)=S(J,1);X0(1,2)=S(J,2);r=S(J,3);w=S(J,4);a=S(J,5);
% L=S(J,6);V=S(J,7);A=S(J,8);T=S(J,9);TStart=S(J,10);TEnd=S(J,11);
% [ XSpiral ] = Spiral( X0,r,w,a,L,V,A,T,TStart,TEnd );
% XSpiral(:,3) = 0;
% Data(J).XSpiral=XSpiral;
% Data(J).TStart=TStart;
% Data(J).TEnd=TEnd;
% end

% 线段
% 未知



%% 补充结构体参数

SysEAmplitude=[0.4,0.2,0.1,0.08,0.04,0,0.02];
SysEInitialAppearance=[pi/16,pi/8,pi/4,pi/2,pi/3,pi/5,pi/6];
for K=1:J
Data(K).ConstantError=0;
Data(K).SysEAmplitude=SysEAmplitude;
Data(K).SysEInitialAppearance=SysEInitialAppearance;
Data(K).GaussianNoise=0.05;
end

%% 观测值添加计算小时解

for I=1:size(Data,2)
    X=Data(I).XCircle;
    x=Data(I).x;
    TStart=Data(I).TStart;
    TEnd=Data(I).TEnd;
    ConstantError=Data(I).ConstantError;
    Amplitude=Data(I).SysEAmplitude;
    InitialAppearance=Data(I).SysEInitialAppearance;
    GaussianNoise=Data(I).GaussianNoise;
    % 给观测值添加观测误差，平差计算出小时解
    [AllHouS,DayS,Es,SysEDis,GDOP11,GDOP22] = AddError_ComputeHourlySolution( X,x,TStart,TEnd,ConstantError,Amplitude,InitialAppearance,GaussianNoise);
    Data(I).AllHouS=AllHouS;
    Data(I).DayS=DayS;
    Data(I).Es=Es;
    Data(I).SysEDis=SysEDis;
    Data(I).GDOP11=GDOP11;
    Data(I).GDOP22=GDOP22;
end

% dAllHous1=AllHouS(:,:,1)-x(1,:);
% dDayS1=DayS(:,:,1)-x(1,:);
% dAllHous2=AllHouS(:,:,2)-x(2,:);
% dDayS2=DayS(:,:,2)-x(2,:);
% dAllHous3=AllHouS(:,:,3)-x(3,:);
% dDayS3=DayS(:,:,3)-x(3,:);
% 
% save('Main\Days10\Circle4000ma005b000.mat');

