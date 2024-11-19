function [INIData] = SVPresampling(INIData)
%SVPRESAMPLING 此处显示有关此函数的摘要
%   此处显示详细说明

load(INIData.SVPFilePath);
[ReferenceTime,ReferencePoint,ArmLength,GlobalRefH,GlobalRefc,GlobalDepthH] = Simulation_GlobalParSetting(INIData);
for i=1:length(ProfileData)
    iprofile = ProfileData{i};
    Date     = iprofile(:,2:6);
    PF = iprofile(:,[8,7]);
    
    [PF,DelProf] = DelBackward(PF);
    %% 特殊处理,同一深度存在大量聚集点
    if i == 4
        PF(end-10:end,:) = [];
    end
    SubProfile = SplitProfile(PF,-GlobalRefH,GlobalDepthH);
    %% 删除逆序、同序
    
    %% 声速剖面重采样
    switch INIData.SVPLayerModel
        case 'Fix'
            SVPResampleFun = @ProfileResample;
        case 'Customize'
            SVPResampleFun = @SVPFixedInterval;
    end
    SubProfile = SVPResampleFun(SubProfile,INIData.MaxH,INIData.LayerLag);
    %% Preparation for plo
    
    win = 3;
    SubProfile = PFGrad(SubProfile,win,1);
    [dL,c1] = DelayError(SubProfile,GlobalRefc,GlobalDepthH + GlobalRefH,1);
    
    Time    = GPSTime2Sec(Date,ReferenceTime);
    MeanTime = mean(Time);
    MiddenTime = median(Time);
    c0 = MeanVel(PF);
    %%
    INIData.SVPSubDate{i}=Date(end:-1:1,:);
    INIData.SVPSubTime{i}=Time(end:-1:1,:);
    INIData.SVPSubMeanTime(i) = MeanTime;
    INIData.SVPSubMiddleTime(i) = MiddenTime;
    INIData.SVPSubPF{i}=PF;
    INIData.SubProfile{i}=SubProfile; %% from 0-2
    INIData.SVPSubc0(i)=c0; %% 加权平均声速
    INIData.SVPSubc1(i)=c1; %% 有效声速
    INIData.SVPSubdL(i)=dL; %% 恒声速与剖面声速垂直传播相比距离残差
end
INIData.SVPLayer = length(INIData.LayerLag) + 1;
INIData.SVPLayerH = SubProfile(:,1);
end

