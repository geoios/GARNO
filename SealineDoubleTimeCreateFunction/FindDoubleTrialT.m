function [DoubleTrialTime,RT_XYZ] = FindDoubleTrialT(X,x,num1,num2,INIData,ProcessData)
num = ProcessData.LineObsNumList(num1,num2);
DoubleTrialTime = zeros(num,1);
RT_XYZ = zeros(num,3);

parfor i = 1:num
    % 首先求初始坐标到达海底坐标点的时间
    [T1] = P2PInvRayTrace(X(i,:),x,ProcessData.SVP{i,num1,num2});
    
    % 假设返程时间初始值T2=T1
    T2=T1;T1=T1+HD;
    
    for j = 1:100
        DoubleT=T2+T1;
        % 海面坐标经过T1+T2+HD时刻，到达的位置X
        [XYZ] = INIData.SurFunction(INIData.SurMP(num1,:),INIData.H,(num2 - 1) * INIData.TSecond);
        % 检验生成后的坐标
        [NewT2] = P2PInvRayTrace(XYZ,x,SVPData(i));

        delatT = T2 - NewT2;
        
        T2 = NewT2;
        
        if delatT == 0
            break;
        end
    end
    DoubleTrialTime(i) = T1 + T2;
    RT_XYZ(i,:) = XYZ;
end
RT_XYZ = RT_XYZ;
end

