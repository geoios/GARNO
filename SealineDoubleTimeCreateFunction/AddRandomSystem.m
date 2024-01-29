function [outputArg1,outputArg2] = AddRandomSystem(P)
%ADDRANDOMSYSTEM 此处显示有关此函数的摘要
%   此处显示详细说明

for i=1:size(P,1)
    % 偶然误差系数
    SurData(i).CoordianteRandom=[0.01,0.01,0.05];
    SurData(i).TimeRandom=10^-5;
    SurData(i).AttitudeRandom=[0.05,0.05,0.05];
    SurData(i).SVPRandom=1;
    SurData(i).ATDRandom=[0.01,0.01,0.01];
    % 系统误差系数
    SurData(i).SolidTideSystem=[0.01,0.01,0.01];
    SurData(i).CoordianteSystem=[10^-3,10^-3,10^-3];
    SurData(i).TimeSystem=10^-5;
    SurData(i).AttitudeSystem=[0.01,0.01,0.01];
    SurData(i).ATDSystem=[0.01,0.01,0.01];
    SurData(i).HardwareDelay= 0.05;   % (可更改参数)
end
end

