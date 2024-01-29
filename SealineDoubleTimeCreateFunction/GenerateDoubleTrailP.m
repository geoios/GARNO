function [OutData] = GenerateDoubleTrailP(Data,OutData,SurData)
% 由时间生成坐标
for J=1:size(OutData,2)
    type=SurData(J).type;H=SurData(J).Hight;T=SurData(J).T;RT_X=[];
    for j=1:size(OutData(J).Sign,2)
        SubSurData=SurData(J);
        TStart=Data(J).TStart(j);
        DT=OutData(J).DoubleTripT2(:,j);
        if type==1
            [RT_X] = ReceiveCircleXY(SubSurData,DT+(j-1)*SubSurData.TSecond);
        elseif type==2
            [RT_X]=ReceiveRosesXY(SubSurData,DT+(j-1)*SubSurData.TSecond);
        elseif type==3
            [RT_X]= ReceiveSpiralXY(SubSurData,DT+(j-1)*SubSurData.TSecond);
        elseif type==4
            [RT_X]=ReceiveSegmentXY(SubSurData,DT+(j-1)*SubSurData.TSecond);
        end
        for k=1:size(OutData(J).ST_X,1)
            RT_X(k,3) =ErrorFunction(H,TStart+(k-1)*T+DT(k));
        end
        OutData(J).RT_X(:,:,j)=RT_X;
    end
end
end