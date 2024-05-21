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

    %% Configuration section
    %INIData = SimulationINISet();
    INIData = SimulationRose(q(w),i0);
    %% Solution section
    % 1.Generate seabed regular polygons and generate sea surface trajectory coordinates (generate seabed responders, sea surface transducer coordinates)
    [INIData,ProcessData,OutData] = GenerateTwoPData(INIData);
    % 2.Transmission time of the transducer
    [ProcessData,OutData] = transducerST(INIData,ProcessData,OutData);
    % 4.Load the required sound velocity profile for simulation (generated during emission)
    [INIData,ProcessData] = GenerateLaunchTPF(INIData,ProcessData,OutData);
    % 5.Generate two-way observation time
    [ProcessData,OutData] = DoubleTrialT(INIData,ProcessData,OutData);
    % 8.Generate attitude angles and arm lengths at launch and reception times, and generate two-way receiving attitudes
    [OutData] = GenerateDoubleTrailA(INIData,ProcessData,OutData);
    % 10.Verify the correctness of time (verify that the usage time is three times longer than the generated data)
    [OutData] = CheckDoubleTime(INIData,ProcessData,OutData);
    %% Generate data section
    % 11. Generate transmit and receive time.mat files
    [INIData,ProcessData,OutData] = OutPutMat(INIData,ProcessData,OutData);
    OutPutJapanDatastruct(INIData,ProcessData,OutData);
   
    close all; clc;close("all");%clear; 

end
end

