function [ProcessData,OutData] = Grid_Interpolation(INIData,ProcessData,OutData)
TNum = INIData.TNum;
% 1.往返声线跟踪同声速剖面
for n = 1:INIData.LineNum
    for m = 1:INIData.TransponderNum
        X = OutData(n).Transducer_ENU_ST(:,:,m);
        x = ProcessData.Transponder_ENU(m,:);
        num = ProcessData.LineObsNumList(n,m);
        HD = INIData.HardwareDelay;
        for k = 1:num

        
        
        
        
        
        end
    end
    OutData(n).DoubleTrialTime = DoubleTrialTimeList;
    OutData(n).Transducer_ENU_RT = RT_XYZList;
    OutData(n).RT_TIME = RT_TIME;
end
ProcessData.RT_ObsSec = RT_ObsSec;
ProcessData.RT_ObsDay = RT_ObsDay;
end

