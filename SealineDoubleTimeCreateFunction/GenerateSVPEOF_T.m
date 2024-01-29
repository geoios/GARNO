function [ProcessData] = GenerateSVPEOF_T(INIData,ProcessData)

EOFA = INIData.SVPMP;
[m,n]=size(EOFA);
for k=1:1:m
    A=[];
    for i=1:length(INIData.SubProfile)
        DayT = INIData.SVPSubMeanTime(i)/3600/24;
        for j=1:1:n
            A(i,j)=ErrorFunction(EOFA{k,j},DayT);
        end
        INIData.A{k}=A;
    end
end
num = 1;
for j=1:INIData.LineNum
    for k=1:INIData.TransponderNum
        for i=1:ProcessData.LineObsNumList(j,k)
            DayOfRT = ProcessData.ST_ObsDay(i,k,j);
            [NewSVP] = RestructureSVP(DayOfRT,INIData);
            SVP{i,k,j}= PFGrad(NewSVP,2,1);
            SVPSpeedList(:,num) = NewSVP(:,2);
            num = num + 1;
        end
    end
end
ProcessData.SVP = SVP;
ProcessData.SVPAvg = [NewSVP(:,1),mean(SVPSpeedList,2)];
end

