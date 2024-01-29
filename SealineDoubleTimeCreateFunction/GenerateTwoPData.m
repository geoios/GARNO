function [INIData,ProcessData,OutData] = GenerateTwoPData(INIData)
%% 海底基准点生成
switch INIData.FloorFrom
    case 'Customize'
        INIData.FloorFunction = @SeafloorCustomizePoints;
    case 'Polygon'
        INIData.FloorFunction = @SeafloorPolygonPoints;
    case 'Polygon + Customize'
        INIData.FloorFunction = @SeafloorPolCusPoints;
end
x = INIData.FloorFunction(INIData.FloorMP,INIData.h);
INIData.TransponderNum = size(x,1);
ProcessData.Transponder_ENU = x;
ProcessData.ExtremeValRanDer = [min(x,[],1),max(x,[],1)];
%% 海面航迹生成
switch INIData.SurFrom
    case 'Cirlce'
        INIData.SurFunction = @ReceiveCircle;
    case 'Roses'
        INIData.SurFunction = @ReceiveRoses;
    case 'Spirl'
        INIData.SurFunction = @ReceiveSpiral;
    case 'Segment'
        INIData.SurFunction = @ReceiveSegment;
end

MP = INIData.SurMP;

% 生成每个测段海面控制点坐标
LineTStart = zeros(INIData.LineNum,INIData.TransponderNum);
LineTEnd = zeros(INIData.LineNum,INIData.TransponderNum);
LineTSpan = zeros(INIData.LineNum,INIData.TransponderNum);
LineObsNumList = zeros(INIData.LineNum,INIData.TransponderNum);
ExtremeValRanCer=[];
for n = 1:INIData.LineNum
    for  m = 1:INIData.TransponderNum
        [X,LTStart,LTEnd,T] = INIData.SurFunction(MP(n,:),INIData.H,(m - 1) * INIData.TSecond);
        Transducer_ENU(:,:,m) = X;
        LineTStart(n,m) = LTStart;
        LineTEnd(n,m) = LTEnd;
        LineTSpan(n,m) = T;
        LineObsNumList(n,m) = size(X,1); 
        ExtremeValRanCer = [ExtremeValRanCer;min(X,[],1),max(X,[],1)];
    end
    OutData(n).Transducer_ENU_ST = Transducer_ENU;
end
ProcessData.LineTStart = LineTStart;
ProcessData.LineTEnd = LineTEnd;
ProcessData.LineTSpan = LineTSpan;
ProcessData.LineObsNumList = LineObsNumList;
ProcessData.ExtremeValRanCer = [min(ExtremeValRanCer(:,1:3),[],1),max(ExtremeValRanCer(:,4:6),[],1)];
end