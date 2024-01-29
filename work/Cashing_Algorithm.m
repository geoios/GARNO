function [ProcessData,OutData] = Cashing_Algorithm(INIData,ProcessData,OutData)
TNum = INIData.TNum;
for n = 1:INIData.LineNum
    for m = 1:INIData.TransponderNum
        X = OutData(n).Transducer_ENU_ST(:,:,m);
        x = ProcessData.Transponder_ENU(m,:);
        num = ProcessData.LineObsNumList(n,m);
        DoubleTrialTime = zeros(num,1);
        RT_XYZ = zeros(num,3);
        HD = INIData.HardwareDelay;
        for k = 1:num
            SVPData.PF = ProcessData.SVP{k,m,n};
            % 首先求初始坐标到达海底坐标点的时间
            [T1] = P2PInvRayTrace(X(k,:),x,SVPData);
            
            % 假设返程时间初始值T2=T1
            T2=T1;T1=T1+HD;
            
            for i = 1:100
                DoubleT = T1 + T2;
                % 海面坐标经过T1+T2+HD时刻，到达的位置X
                [XYZ] = INIData.SurFunction(INIData.SurMP(n,:),INIData.H,DoubleT+(k-1)*TNum+(m-1)*INIData.TSecond,INIData.HardwareDelay);
                % 检验生成后的坐标
                [NewT2] = P2PInvRayTrace(XYZ,x,SVPData);
                
                delatT = T2 - NewT2;
                
                T2 = NewT2;
                
                if delatT == 0
                    break;
                end
            end
            DoubleTrialTime(k) = T1 + T2;
            RT_XYZ(k,:) = XYZ;
        end
        TStart = ProcessData.LineTStart(n,m);
        TEnd = ProcessData.LineTEnd(n,m);
        T = ProcessData.LineTSpan(n,m);
        [TIME,ObsSec,ObsDay] = TimeCreate(INIData.LaunchRT,TStart,TEnd,T,DoubleTrialTime);
        RT_TIME(:,:,m) = TIME;
        RT_ObsSec(:,m,n) = ObsSec;
        RT_ObsDay(:,m,n) = ObsDay;
        DoubleTrialTimeList(:,m) = DoubleTrialTime;
        RT_XYZList(:,:,m) = RT_XYZ;
    end
    OutData(n).DoubleTrialTime = DoubleTrialTimeList;
    OutData(n).Transducer_ENU_RT = RT_XYZList;
    OutData(n).RT_TIME = RT_TIME;
end
ProcessData.RT_ObsSec = RT_ObsSec;
ProcessData.RT_ObsDay = RT_ObsDay;

end

