function [DoubleTrialTime,SVPEnd,RT_X] = FindDoubleTrialT2(X,x,num,Data,SurData,NeedData)
DoubleTrialTime=[];TT=[];T=SurData.T;type=SurData.type;
HD=SurData.HardwareDelay;Hight= SurData.Hight;SVPData=SurData.MTSVP(num).SVPData;
TStart=Data.TStart(num);SVPRandom=SurData.SVPRandom;
LaunchRT=NeedData.LaunchRT;
RrferTD=datetime(LaunchRT(1),LaunchRT(2),LaunchRT(3));
RrferT=day(RrferTD,'dayofyear');
RT=RrferT*24*3600+LaunchRT(4)*3600+LaunchRT(5)*60+LaunchRT(6);
parfor i=1:size(X,1)
    % 生成海面换能器坐标
    Correct_X=X(i,:);Correct_x=x;
    % 首先求初始坐标到达海底坐标点的时间
    if SVPRandom~=2
        [T1] = P2PInvRayTrace(Correct_X,Correct_x,SVPData(i));
    else
        T1=norm(Correct_X-Correct_x)/SVPData(i).PF(1,2);
    end
    % 假设返程时间初始值T2=T1
    T2=T1;T1=T1+HD;
    for j=1:100
        DoubleT=T2+T1;XYZ=[];
        % 海面坐标经过T1+T2+HD时刻，到达的位置X
        % XY函数生成
        if type==1
            [XYZ]=ReceiveCircleXY(SurData,DoubleT+(i-1)*T+(num-1)*SurData.TSecond);
        elseif type==2
            [XYZ]=ReceiveRosesXY(SurData,DoubleT+(i-1)*T+(num-1)*SurData.TSecond);
        elseif type==3
            [XYZ]=ReceiveSpiralXY(SurData,DoubleT+(i-1)*T+(num-1)*SurData.TSecond);
        elseif type==4
            [XYZ]=ReceiveSegmentXY(SurData,DoubleT+(i-1)*T+(num-1)*SurData.TSecond);
        end
        %  高程生成
        XYZ(3)= ErrorFunction(Hight,TStart+(i-1)*T+DoubleT);
        % 检验生成后的坐标
        XYZ_Correct=XYZ;
        
        if SVPRandom~=2
            if j==1
                [NewT2] = P2PInvRayTrace(XYZ_Correct,Correct_x,SVPData(i));
            else
                [NewT2] = P2PInvRayTrace(XYZ_Correct,Correct_x,RESData);
            end
        else
            NewT2=norm(XYZ_Correct-Correct_x)/SVPData(i).PF(1,2);
        end
        delatT=T2-NewT2;
        T2=NewT2;
        
        if delatT==0
            break;
        else
            DayOfRT=(TStart+(i-1)*T-RT+T1+T2)/3600/24;
            [RESData] = RestructureSVP3(DayOfRT,NeedData);
        end
    end
    SVPEnd(i)=RESData;
    DoubleTrialTime(i)=T1+T2;
    RT_X(i,:)=XYZ_Correct;
    %TT=[TT;T1,T2,T1+T2];
end
DoubleTrialTime=DoubleTrialTime';
end

