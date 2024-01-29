function [GlobalRefT, GlobalRefP,GlobalArmLength,GlobalRefH,GlobalRefc,GlobalDepthH,Globalc1,Interval, HardDelay] = Simulation_GlobalParSetting(INIData)

GlobalRefT = INIData.LaunchRT(2:end);  % 参考转换时刻
%% 固体潮为零; 
GlobalRefP = [-2686643.38952782,5410552.69054612,2039760.98252097]; % 参考转换点                        
GlobalRefH = 0;           % 参考转换高程      
GlobalDepthH  = 3069;

GlobalArmLength = [INIData.Forward;INIData.Rightward;INIData.Downward];

Globalc1     = 1.479047302627320e+03;
GlobalRefc   = 1.479047302627320e+03;

Interval = 8;
HardDelay = 0;
end







