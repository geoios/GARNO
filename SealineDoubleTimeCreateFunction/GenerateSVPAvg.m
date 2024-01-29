function [ProcessData] = GenerateSVPAvg(INIData,ProcessData,OutData)

PF=INIData.SubProfile;

SoundVMatrix=[];
for i=1:length(PF)
    SoundVMatrix=[SoundVMatrix,PF{i}(1:end,2)];
end
SVPAvg=mean(SoundVMatrix,2);
ProcessData.SurSVPAvg=[PF{1}(1:end,1),SVPAvg];

end

