function [OutData,SurData] = DoubleTrialT2(Data,SurData,OutData,NeedData)
% 假定硬件延迟；高程函数
% 方法三：使用阿基里斯悖论的方式逼近
for i=1:size(Data,2)
    SurData(i).Hight=SurData(i).H(i,:);
    for j=1:size(OutData(i).Sign,2)
        X=OutData(i).ST_X(:,:,j);
        x=Data(i).x(:,3*j-2:3*j);
        [DoubleTrialTime,SVPEnd,RT_X]=FindDoubleTrialT2(X,x,j,Data(i),SurData(i),NeedData);
        OutData(i).DoubleTripT2(:,j)=DoubleTrialTime;
        SurData(i).MTSVP(j).SVPEnd=SVPEnd;
        OutData(i).RT_X(:,:,j)=RT_X;
    end
end

end

