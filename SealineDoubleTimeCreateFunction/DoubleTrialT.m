function [ProcessData,OutData] = DoubleTrialT(INIData,ProcessData,OutData)

switch INIData.DouTCalModel
    case 'Cashing'
       INIData.CalDouTrialT = @Cashing_Algorithm;
    case 'GridInter'
       INIData.CalDouTrialT = @Grid_Interpolation;
end

[ProcessData,OutData] = INIData.CalDouTrialT(INIData,ProcessData,OutData);

end

