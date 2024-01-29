function [ProcessData] = GenerateSVPConst(INIData,ProcessData,OutData)

MonolayerFun=INIData.MonolayerFun;
ProcessData.MonolayerSVP=[[PF{1}(1,1);PF{1}(num,1)],ErrorFunction(MonolayerFun,T)*ones(2,1)];


end

