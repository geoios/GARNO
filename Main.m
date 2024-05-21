q = [2.8 3 3.2 3.4 3.6 3.8 4];
for w = 1:1:length(q)
for i0 = 1:500
    q(w)
    i0
    
    %% Get the location of the current script
    ScriptPath      = mfilename('fullpath');      % Script location
    [FilePath] = fileparts(ScriptPath);      % Folder location
    cd(FilePath);
    clear FilePath;

    %% 配置部分
    %INIData = SimulationINISet();
    INIData = SimulationRose(q(w),i0);
    %% 解算部分
    % 1.生成海底正多边形和生成海面轨迹 坐标 (生成海底应答器，海面换能器坐标)
    [INIData,ProcessData,OutData] = GenerateTwoPData(INIData);
    % 2.换能器发射时间
    [ProcessData,OutData] = transducerST(INIData,ProcessData,OutData);
    % 4.加载模拟所需的声速剖面（发射时刻声速剖面生成）
    [INIData,ProcessData] = GenerateLaunchTPF(INIData,ProcessData,OutData);
    % 5.生成双程观测时间
    [ProcessData,OutData] = DoubleTrialT(INIData,ProcessData,OutData);
    % 8.发射时刻、接受时刻的姿态角、臂长生成 ,生成双程接收姿态
    [OutData] = GenerateDoubleTrailA(INIData,ProcessData,OutData);
    % 10.检验时间正确性(检验使用消耗时间是生成数据的3倍)
    [OutData] = CheckDoubleTime(INIData,ProcessData,OutData);
    %% 生成数据部分
    % 11.生成发射时刻、接收时刻.mat文件
    [INIData,ProcessData,OutData] = OutPutMat(INIData,ProcessData,OutData);
    OutPutJapanDatastruct(INIData,ProcessData,OutData);
   
    close all; clc;close("all");%clear; 

end
end

