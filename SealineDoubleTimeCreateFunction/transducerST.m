function [ProcessData,OutData] = transducerST(INIData,ProcessData,OutData)
%%  海面观测点发射时刻生成
for n=1:INIData.LineNum
    
    for m=1:INIData.TransponderNum
        TStart = ProcessData.LineTStart(n,m);
        TEnd = ProcessData.LineTEnd(n,m);
        T = ProcessData.LineTSpan(n,m);
        
        [TIME,ObsSec,ObsDay] = TimeCreate(INIData.LaunchRT,TStart,TEnd,T);
        
        ST_TIME(:,:,m)=TIME;
        ST_ObsSec(:,m,n) = ObsSec;
        ST_ObsDay(:,m,n) = ObsDay;
       
        OutData(n).TransponderNameIndex(1:ProcessData.LineObsNumList(n,m),m) = m;
    end
    OutData(n).ST_TIME = ST_TIME;
    
end
ProcessData.ST_ObsSec = ST_ObsSec;
ProcessData.ST_ObsDay = ST_ObsDay;
end