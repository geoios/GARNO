function [INIData,ProcessData] = GenerateLaunchTPF(INIData,ProcessData,OutData)
SVPRandom = INIData.SVPRandom;
%% 仿真剖面生成模式 
switch SVPRandom
    case 'SVPAvg'
       INIData.SVPGenerateFuntion = @GenerateSVPAvg;
    case 'EOF'
       INIData.SVPGenerateFuntion = @GenerateSVPEOF_T;
    case 'Constant'
        INIData.SVPGenerateFuntion =  @GenerateSVPConst;
    case 'Pseudo-3D'
        INIData.SVPGenerateFuntion = @GenerateSVPPseudo_3D;
    case 'Grid'
        INIData.SVPGenerateFuntion = @GenerateSVPGrid;
end

[ProcessData] = INIData.SVPGenerateFuntion(INIData,ProcessData,OutData);


end

