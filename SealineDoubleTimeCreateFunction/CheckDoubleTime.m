function [OutData] = CheckDoubleTime(INIData,ProcessData,OutData)
for n=1:INIData.LineNum
    CheckT1=[];CheckT2=[];SVPData=[];HardwareDelay=INIData.HardwareDelay;
    Forward = INIData.Forward;Rightward=INIData.Rightward;Downward=INIData.Downward;
    Correct_XStart=[];Correct_XEnd=[];
    for m=1:INIData.TransponderNum
        % 天线坐标
        XStart=OutData(n).ST_AX(:,:,m);XEnd=OutData(n).RT_AX(:,:,m);
        HeandingStart=OutData(n).ST_HEADING(:,m);PitchStart=OutData(n).ST_PITCH(:,m);RollStart=OutData(n).ST_ROLL(:,m);
        HeandingEnd=OutData(n).RT_HEADING(:,m);PitchEnd=OutData(n).RT_PITCH(:,m);RollEnd=OutData(n).RT_ROLL(:,m);
        % 坐标转换
        
        for k=1:ProcessData.LineObsNumList(n,m)
            [ pole_de,pole_dn,pole_du ] = Transform( HeandingStart(k),PitchStart(k),RollStart(k),Forward,Rightward,Downward );
            Correct_XStart(k,:) =  XStart(k,:)+[pole_de,pole_dn,pole_du];
            [ pole_de,pole_dn,pole_du ] = Transform( HeandingEnd(k),PitchEnd(k),RollEnd(k),Forward,Rightward,Downward );
            Correct_XEnd(k,:) = XEnd(k,:)+[pole_de,pole_dn,pole_du];   %% (k,:)
            SVPData.PF = ProcessData.SVP{k,m,n};
            [CheckT1(k,m)] = P2PInvRayTrace(Correct_XEnd(k,:),ProcessData.Transponder_ENU(m,:),SVPData);
            [CheckT2(k,m)] = P2PInvRayTrace(Correct_XStart(k,:),ProcessData.Transponder_ENU(m,:),SVPData); %
        end
    end
    OutData(n).DetalT=CheckT1+CheckT2+HardwareDelay-OutData(n).DoubleTrialTime;
end
end

 