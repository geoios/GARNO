function [outputArg1,outputArg2] = OutPutMat2(inputArg1,inputArg2)
%OUTPUTMAT2 此处显示有关此函数的摘要
%   此处显示详细说明

if model==1
    % 保存声速剖面模拟观测数据.mat
    SaveAddress=NeedData.SaveAddress;
    SVPObsAvg=OutData(1).LSVPAvg;
    save([SaveAddress,'SVPObsAvg.mat'],'SVPObsAvg');
    for i=1:size(OutData,2)
        LSVPObsAvg=OutData(i).LSVPAvg;
        save([SaveAddress,'L',num2str(i),'_SVPObsAvg.mat'],'LSVPObsAvg');
    end
    % 保存海底点以及臂长参数
    for i=1:size(OutData,2)
        STATD=[SurData(i).STForward,SurData(i).STRightward,SurData(i).STDownward];
        RTATD=[SurData(i).RTForward,SurData(i).RTRightward,SurData(i).RTDownward];
        T_x_ATD=[Data(i).x,STATD,RTATD];
        save([SaveAddress,'L',num2str(i),'_T_x_ATD.mat'],'T_x_ATD');
    end
    
    for i=1:size(OutData,2)
        ATD=[SurData(i).Forward,SurData(i).Rightward,SurData(i).Downward];
        x_ATD=[Data(i).xx;ATD];
        save([SaveAddress,'L',num2str(i),'_x_ATD.mat'],'x_ATD');
    end
    
    % 保存海面观测数据.mat
    for i=1:size(OutData,2)
        for j=1:size(OutData(i).OutputS,3)
            OutputS=OutData(i).OutputS(:,:,j);
            str = sprintf('L%d_Point%d_%s',i,j,'S');
            eval([str,'=0']);
            assignin('base',str,OutputS)
            save([SaveAddress,str,'.mat'],str);
        end
        for j=1:size(OutData(i).OutputB,3)
            OutputB=OutData(i).OutputB(:,:,j);
            str = sprintf('L%d_Point%d_%s',i,j,'B');
            eval([str,'=0']);
            assignin('base',str,OutputB)
            save([SaveAddress,str,'.mat'],str);
        end
    end
    save([SaveAddress,'data.mat'])
elseif model==2
    %% P2P Data2
    % 声速剖面
    SaveAddress=NeedData.SaveAddress;
    SVPObsAvg=OutData(1).LSVPAvg;
    save([SaveAddress,'SVPObsAvg.mat'],'SVPObsAvg');
    
    
    for i=1:size(Data2,2)
        LSVPObsAvg=SurData(1).SVPData(i).PF;
        save([SaveAddress,'L',num2str(i),'_SVPObsAvg.mat'],'LSVPObsAvg');
    end
    
    % 海底坐标点及ATD
    i=1;
    ATD=[SurData(i).Forward,SurData(i).Rightward,SurData(i).Downward];
    x_ATD=[Data(i).xx;ATD];
    save([SaveAddress,'x_ATD.mat'],'x_ATD');
    
    % 保存海面观测数据.mat
    for i=1:size(Data2,2)
        for j=1:size(Data2(i).OutputS,3)
            OutputS=Data2(i).OutputS(:,:,j);
            str = sprintf('L%d_Point%d_%s',i,j,'S');
            eval([str,'=0']);
            assignin('base',str,OutputS)
            save([SaveAddress,str,'.mat'],str);
        end
        for j=1:size(Data2(i).OutputB,3)
            OutputB=Data2(i).OutputB(:,:,j);
            str = sprintf('L%d_Point%d_%s',i,j,'B');
            eval([str,'=0']);
            assignin('base',str,OutputB)
            save([SaveAddress,str,'.mat'],str);
        end
    end
    save([SaveAddress,'data.mat'])
    
else
    error('model ~=1 or 2');
    
end
end

