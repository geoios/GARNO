function [OutPutStruct,INIData] = ObsStructRetort(INIData,ProcessData,OutData)

ll=1;
% 保存海面观测数据.mat
for n=1:INIData.LineNum
    for m=1:1:INIData.TransponderNum
        OutputS=OutData(n).OutputS(:,:,m);
        OutputB=OutData(n).OutputB(:,:,m);
        for k=1:ProcessData.LineObsNumList(n,m)
            OutPutStruct0.SET(ll,1)= {'S01'};
            OutPutStruct0.LN(ll,1)={['L',num2str(n,'%02d')]};
            OutPutStruct0.MT(ll,1)={['M',num2str(m,'%02d')]};
            OutPutStruct0.flag(ll,1)={'FALSE'};
            DayOfyear = day(datetime(INIData.LaunchRT(1),OutputS(k,1),OutputS(k,2)),'dayofyear');
            DayOfyear2 = day(datetime(INIData.LaunchRT(1),INIData.LaunchRT(2),INIData.LaunchRT(3)),'dayofyear');
            OutPutStruct0.ST(ll,1) = (DayOfyear-DayOfyear2)*24*3600 + OutputS(k,3) * 3600 + OutputS(k,4) * 60 + OutputS(k,5);
            DayOfyear = day(datetime(INIData.LaunchRT(1),OutputB(k,1),OutputB(k,2)),'dayofyear');
            OutPutStruct0.RT(ll,1) = (DayOfyear-DayOfyear2)*24*3600 + OutputB(k,3)*3600 + OutputB(k,4)*60 + OutputB(k,5);
            OutPutStruct0.TT(ll,1) = OutputB(k,7);
            OutPutStruct0.ResiTT(ll,1) = 0;
            OutPutStruct0.TakeOff(ll,1) = 0;
            OutPutStruct0.gamma(ll,1) = 0;
            OutPutStruct0.ant_e0(ll,1) = OutputS(k,6);
            OutPutStruct0.ant_n0(ll,1) = OutputS(k,7);
            OutPutStruct0.ant_u0(ll,1)= OutputS(k,8);
            OutPutStruct0.head0(ll,1) = OutputS(k,9);
            OutPutStruct0.pitch0(ll,1) = OutputS(k,10);
            OutPutStruct0.roll0(ll,1) = OutputS(k,11);
            OutPutStruct0.ant_e1(ll,1) = OutputB(k,8);
            OutPutStruct0.ant_n1(ll,1) = OutputB(k,9);
            OutPutStruct0.ant_u1(ll,1) = OutputB(k,10);
            OutPutStruct0.head1(ll,1) = OutputB(k,11);
            OutPutStruct0.pitch1(ll,1) = OutputB(k,12);
            OutPutStruct0.roll1(ll,1) = OutputB(k,13);
            
            
            ll=ll+1;
        end
    end
end
[~,I]=sort(OutPutStruct0.ST);
OutPutStruct.SET = OutPutStruct0.SET(I);
OutPutStruct.LN = OutPutStruct0.LN(I);
OutPutStruct.MT = OutPutStruct0.MT(I);
OutPutStruct.TT = OutPutStruct0.TT(I);
OutPutStruct.ResiTT = OutPutStruct0.ResiTT(I);
OutPutStruct.TakeOff = OutPutStruct0.TakeOff(I);
OutPutStruct.gamma = OutPutStruct0.gamma(I);
OutPutStruct.flag = OutPutStruct0.flag(I);
OutPutStruct.ST = OutPutStruct0.ST(I);
OutPutStruct.ant_e0 = OutPutStruct0.ant_e0(I);
OutPutStruct.ant_n0 = OutPutStruct0.ant_n0(I);
OutPutStruct.ant_u0 = OutPutStruct0.ant_u0(I);
OutPutStruct.head0 = OutPutStruct0.head0(I);
OutPutStruct.pitch0 = OutPutStruct0.pitch0(I);
OutPutStruct.roll0 = OutPutStruct0.roll0(I);
OutPutStruct.RT = OutPutStruct0.RT(I);
OutPutStruct.ant_e1 = OutPutStruct0.ant_e1(I);
OutPutStruct.ant_n1 = OutPutStruct0.ant_n1(I);
OutPutStruct.ant_u1 = OutPutStruct0.ant_u1(I);
OutPutStruct.head1 = OutPutStruct0.head1(I);
OutPutStruct.pitch1 = OutPutStruct0.pitch1(I);
OutPutStruct.roll1 = OutPutStruct0.roll1(I);

INIData.Obs_Shot = length(I);
end

