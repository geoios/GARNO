function [x] = OutPutJapanDatastruct(INIData,ProcessData,OutData)
%% 声速剖面构建
SVPAvgStruct.depth=ProcessData.SVPRef(:,1);
SVPAvgStruct.speed=ProcessData.SVPRef(:,2);
struct2csv(SVPAvgStruct,INIData.SVPaddress);

%% 观测文件构建
[OutPutStruct,INIData] = ObsStructRetort(INIData,ProcessData,OutData);
struct2csv(OutPutStruct,INIData.Obsaddress,INIData.FileINIAddress);

%% 配置文件构建
[writeKeys] = INIFileKey(INIData,ProcessData);
inifile(INIData.Iniaddress,'write',writeKeys,'plain');

%% 保存所有数据结构体
if INIData.SaveModel ~= 0
    save(INIData.MatAddress,'INIData','ProcessData','OutData');
end
end

