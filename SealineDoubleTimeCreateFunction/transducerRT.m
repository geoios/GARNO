function [OutData] = transducerRT(NeedData,Data,SurData,OutData)
Year=NeedData.Year;
for i=1:size(Data,2)
    T=SurData(i).T;
    for j=1:size(OutData(i).Sign,2)
        TStart=Data(i).TStart(j);TEnd=Data(i).TEnd(j);
        [TIME] = TimeCreate(Year,TStart,TEnd,T,OutData(i).DoubleTripT2(:,j));
        OutData(i).RT_TIME(:,:,j)=TIME;
    end
end
end

