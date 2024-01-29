function [OutData] = GenerateDoubleTrailA(INIData,ProcessData,OutData)
% 生成 HEADING PITCH ROLL    % 生成 ATD
% HEADING:北偏东为+   PITCH:船头向上为+   ROLL:右舷向上为+
for n = 1:INIData.LineNum
    ErrorATD = INIData.ATDError;
    for m = 1:INIData.TransponderNum
        % 发射时刻
        ST = ProcessData.ST_ObsDay(:,m,n);
        OutData(n).STForward(:,m) = INIData.Forward+ErrorFunction(ErrorATD(1,:),ST);
        OutData(n).STRightward(:,m) = INIData.Rightward+ErrorFunction(ErrorATD(2,:),ST);
        OutData(n).STDownward(:,m) = INIData.Downward+ErrorFunction(ErrorATD(3,:),ST);
        % 接收时刻
        RT = ProcessData.RT_ObsDay(:,m,n);
        OutData(n).RTForward(:,m) = INIData.Forward+ErrorFunction(ErrorATD(1,:),RT);
        OutData(n).RTRightward(:,m) = INIData.Rightward+ErrorFunction(ErrorATD(2,:),RT);
        OutData(n).RTDownward(:,m) = INIData.Downward+ErrorFunction(ErrorATD(3,:),RT);
    end
end

%% 生成姿态角
for n = 1:INIData.LineNum
    AttitudeFun=INIData.AttitudeFun;
    for m = 1:INIData.TransponderNum
        % 生成收发射时刻姿态角
        ST = ProcessData.ST_ObsDay(:,m,n);
        ST_Xdetal = INIData.SurFunction(INIData.SurMP(n,:),INIData.H,...
            (m - 1) * INIData.TSecond*ones(ProcessData.LineObsNumList(n,m),1),10^-5);
        betaST = AttitudeCreate(OutData(n).Transducer_ENU_ST(:,:,m),ST_Xdetal);
        OutData(n).ST_HEADING(:,m)=betaST+ErrorFunction(AttitudeFun(1,:),ST);
        OutData(n).ST_PITCH(:,m)=ErrorFunction(AttitudeFun(2,:),ST);
        OutData(n).ST_ROLL(:,m)=ErrorFunction(AttitudeFun(3,:),ST);
        % 生成接收时刻姿态角
        RT = ProcessData.RT_ObsDay(:,m,n);
        RT_Xdetal = INIData.SurFunction(INIData.SurMP(n,:),INIData.H,...
            (m - 1) * INIData.TSecond*ones(ProcessData.LineObsNumList(n,m),1),10^-5);
        betaRT = AttitudeCreate(OutData(n).Transducer_ENU_RT(:,:,m),RT_Xdetal);
        OutData(n).RT_HEADING(:,m) = betaRT+ErrorFunction(AttitudeFun(1,:),RT);
        OutData(n).RT_PITCH(:,m) = ErrorFunction(AttitudeFun(2,:),RT);
        OutData(n).RT_ROLL(:,m) = ErrorFunction(AttitudeFun(3,:),RT);
    end
end

%% 接收GNSS天线位置确定
for n = 1:INIData.LineNum
    STForward=OutData(n).STForward;STRightward=OutData(n).STRightward;STDownward=OutData(n).STDownward;
    RTForward=OutData(n).RTForward;RTRightward=OutData(n).RTRightward;RTDownward=OutData(n).RTDownward;
    for m = 1:INIData.TransponderNum
        STHeading=OutData(n).ST_HEADING(:,m);STPitch=OutData(n).ST_PITCH(:,m);STRoll=OutData(n).ST_ROLL(:,m);
        RTHeading=OutData(n).RT_HEADING(:,m);RTPitch=OutData(n).RT_PITCH(:,m);RTRoll=OutData(n).RT_ROLL(:,m);
        SX = OutData(n).Transducer_ENU_ST(:,:,m);RX = OutData(n).Transducer_ENU_RT(:,:,m);
        for k=1:ProcessData.LineObsNumList(n,m)
            [ st_pole_de(k),st_pole_dn(k),st_pole_du(k)] = Transform( STHeading(k),STPitch(k),STRoll(k),STForward(k),STRightward(k),STDownward(k));
            [ rt_pole_de(k),rt_pole_dn(k),rt_pole_du(k)] = Transform( RTHeading(k),RTPitch(k),RTRoll(k),RTForward(k),RTRightward(k),RTDownward(k));
        end
        OutData(n).ST_AX(:,:,m)=SX-[ st_pole_de',st_pole_dn',st_pole_du'];
        OutData(n).RT_AX(:,:,m)=RX-[ rt_pole_de',rt_pole_dn',rt_pole_du'];
        st_pole_de=[];st_pole_dn=[];st_pole_du=[];rt_pole_de=[];rt_pole_dn=[];rt_pole_du=[];
    end
    STForward=[];STRightward=[];STDownward=[];RTForward=[];RTRightward=[];RTDownward=[];
end
end

