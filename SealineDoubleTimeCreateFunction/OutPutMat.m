function [INIData,ProcessData,OutData] = OutPutMat(INIData,ProcessData,OutData)
%% 临近输出给所有观测量添加偶然误差
% 发射、接收时刻GNSS天线偶然和系统误差
ErrorC = INIData.CoordianteError;ErrorA = INIData.AttitudeError;
ErrorT = INIData.TimeError;ErrorTSer = INIData.TimeSerivceError;
for n = 1:INIData.LineNum
    for m = 1:INIData.TransponderNum
        ST = ProcessData.ST_ObsSec(:,m,n);
        OutData(n).ST_AX_Noise(:,:,m)     =   OutData(n).ST_AX(:,:,m)+ErrorFunction(ErrorC,ST);
        OutData(n).ST_HEADING_Noise(:,m)  =   OutData(n).ST_HEADING(:,m)+ErrorFunction(ErrorA(1,:),ST);
        OutData(n).ST_PITCH_Noise(:,m)    =   OutData(n).ST_PITCH(:,m)+ErrorFunction(ErrorA(2,:),ST);
        OutData(n).ST_ROLL_Noise(:,m)     =   OutData(n).ST_ROLL(:,m)+ErrorFunction(ErrorA(3,:),ST);
        
        RT = ProcessData.RT_ObsSec(:,m,n) + OutData(n).DoubleTrialTime(:,m);
        OutData(n).RT_AX_Noise(:,:,m) = OutData(n).RT_AX(:,:,m)+ErrorFunction(ErrorC,RT);
        OutData(n).RT_HEADING_Noise(:,m)=OutData(n).RT_HEADING(:,m)+ErrorFunction(ErrorA(1,:),RT);
        OutData(n).RT_PITCH_Noise(:,m)=OutData(n).RT_PITCH(:,m)+ErrorFunction(ErrorA(2,:),RT);
        OutData(n).RT_ROLL_Noise(:,m)=OutData(n).RT_ROLL(:,m)+ErrorFunction(ErrorA(3,:),RT);
        
        OutData(n).DoubleTrialTime_Noise(:,m) = OutData(n).DoubleTrialTime(:,m)+ErrorFunction(ErrorT,ST);
        
        TStart = ProcessData.LineTStart(n,m);
        TEnd = ProcessData.LineTEnd(n,m);
        T = ProcessData.LineTSpan(n,m);
        
        ST_Noise = ErrorFunction(ErrorTSer,ST);
        RT_Noise = ErrorFunction(ErrorTSer,RT) + OutData(n).DoubleTrialTime_Noise(:,m);
        OutData(n).ST_TIME_Noise(:,:,m) = TimeCreate(INIData.LaunchRT,TStart,TEnd,T,ST_Noise);
        OutData(n).RT_TIME_Noise(:,:,m) = TimeCreate(INIData.LaunchRT,TStart,TEnd,T,RT_Noise);
    end
    
end


for n=1:INIData.LineNum
    for m=1:INIData.TransponderNum
        OutData(n).OutputS(:,:,m)=[OutData(n).ST_TIME_Noise(:,:,m),OutData(n).ST_AX_Noise(:,:,m),...
            OutData(n).ST_HEADING_Noise(:,m),OutData(n).ST_PITCH_Noise(:,m),OutData(n).ST_ROLL_Noise(:,m)];
        OutData(n).OutputB(:,:,m)=[OutData(n).RT_TIME_Noise(:,:,m),OutData(n).TransponderNameIndex(:,m),OutData(n).DoubleTrialTime_Noise(:,m),OutData(n).RT_AX_Noise(:,:,m),...
            OutData(n).RT_HEADING_Noise(:,m),OutData(n).RT_PITCH_Noise(:,m),OutData(n).RT_ROLL_Noise(:,m)];
    end
end

%% 粗差添加函数
% STMistake=INIData.STMistake;RTMistake=INIData.RTMistake;sign=[-1,1];
% STAMistake=INIData.STAMistake;RTAMistake=INIData.RTAMistake;
% for i=1:INIData.LineNum
%     for j=1:INIData.TransponderNum
%         EpochNum(i,j)=size(OutData(i).OutputS(:,:,j),1);
%     end
% end
% 
% % 指定粗差参数
% ASGN=INIData.EporchAssign;
% AssignMistake=INIData.AssignMistake;
% 
% % 随机粗差参数
% PCT=INIData.EporchPencent;
% PencentMistake=INIData.PencentMistake;
% 
% for i=1:INIData.LineNum
%     [asgnST,asgnRT]=ASGN{i,:};[mistakeST,mistakeRT]=AssignMistake{i,:};
%     for j=1:INIData.TransponderNum
%         A=1:1:EpochNum(i,j);STrandom_num=[];RTrandom_num=[];
%         STASGN_num=asgnST(j,:);A(STASGN_num)=[];n=length(STASGN_num);
%         %%%%发射时刻指定历元、随机历元粗差添加
%         random_num = A(randperm(numel(A),round(PCT*EpochNum(i,j))));                 % 随机筛选历元
%         STrandom_num(j,:) = sort(random_num);                                    % 历元排序
%         OutData(i).STaddError(:,:,j)=zeros(length(random_num)+n,size(OutData(i).OutputS(:,:,j),2)+1); % 构建误差空白排列矩阵
%         STA_num = STAMistake(randi(numel(STAMistake),1,n));                              %指定筛选列
%         ST_num = STMistake(randi(numel(STMistake),1,round(PCT*EpochNum(i,j))));       % 随机筛选列
%         
%         % 指定粗差填充
%         for k=1:1:n
%             if STA_num(k)>5 && STA_num(k)<9
%                 mistakeST(2:2)=mistakeST(2:2)*sign(randperm(numel(sign),1));
%                 OutData(i).STaddError(k,STA_num(k),j)=ErrorFunction(mistakeST(2,:),0);
%             elseif STA_num(k)>8 && STA_num(k)<12
%                 mistakeST(3:2)=mistakeST(3:2)*sign(randperm(numel(sign),1));
%                 OutData(i).STaddError(k,STA_num(k),j)=ErrorFunction(mistakeST(3,:),0);
%             end
%         end
%         % 随机粗差填充
%         for k=1:1:length(ST_num)
%             if ST_num(k)>5&& ST_num(k)<9
%                 PencentMistake(2:2)=PencentMistake(2:2)*sign(randperm(numel(sign),1));
%                 OutData(i).STaddError(k+n,ST_num(k),j)=ErrorFunction(PencentMistake(2,:),0);
%             elseif ST_num(k)>8&& ST_num(k)<12
%                 PencentMistake(3:2)=PencentMistake(3:2)*sign(randperm(numel(sign),1));
%                 OutData(i).STaddError(k+n,ST_num(k),j)=ErrorFunction(PencentMistake(3,:),0);
%             end
%         end
%         OutData(i).OutputS([STASGN_num,STrandom_num(j,:)],STMistake,j)=OutData(i).OutputS([STASGN_num,STrandom_num(j,:)],STMistake,j)+OutData(i).STaddError(:,STMistake,j);
%         OutData(i).STaddError(:,end,j)=[STASGN_num,STrandom_num(j,:)]';
%         
%         %%%%-----------------------------------------------------------------------------------------------%%%%
%         A=1:1:EpochNum(i,j);
%         RTASGN_num=asgnRT(j,:);A(RTASGN_num)=[];m=length(RTASGN_num);
%         %%%%接收时刻随机历元粗差添加
%         random_num = A(randperm(numel(A),round(PCT*EpochNum(i,j))));
%         RTrandom_num(j,:) = sort(random_num);
%         OutData(i).RTaddError(:,:,j)=zeros(length(random_num)+m,size(OutData(i).OutputB(:,:,j),2)+1);
%         RTA_num = RTAMistake(randi(numel(RTAMistake),1,m));
%         RT_num = RTMistake(randi(numel(RTMistake),1,round(PCT*EpochNum(i,j))));
%         
%         % 指定粗差填充
%         for k=1:1:m
%             if RTA_num(k)==7
%                 mistakeRT(1,2)=mistakeRT(1,2)*sign(randperm(numel(sign),1));
%                 OutData(i).RTaddError(k,RTA_num(k),j)=ErrorFunction(mistakeRT(1,:),0);
%             elseif RTA_num(k)>7&& RTA_num(k)<11
%                 mistakeRT(2,2)=mistakeRT(2,2)*sign(randperm(numel(sign),1));
%                 OutData(i).RTaddError(k,RTA_num(k),j)=ErrorFunction(mistakeRT(2,:),0);
%             elseif RTA_num(k)>10&& RTA_num(k)<14
%                 mistakeRT(3,2)=mistakeRT(3,2)*sign(randperm(numel(sign),1));
%                 OutData(i).RTaddError(k,RTA_num(k),j)=ErrorFunction(mistakeRT(3,:),0);
%             end
%         end
%         for k=1:1:length(RT_num)
%             if RT_num(k)==7
%                 PencentMistake(1,2)=PencentMistake(1,2)*sign(randperm(numel(sign),1));
%                 OutData(i).RTaddError(k+m,RT_num(k),j)=ErrorFunction(PencentMistake(1,:),0);
%             elseif RT_num(k)>7&& RT_num(k)<11
%                 PencentMistake(2,2)=PencentMistake(2,2)*sign(randperm(numel(sign),1));
%                 OutData(i).RTaddError(k+m,RT_num(k),j)=ErrorFunction(PencentMistake(2,:),0);
%             elseif RT_num(k)>10&& RT_num(k)<14
%                 PencentMistake(3,2)=PencentMistake(3,2)*sign(randperm(numel(sign),1));
%                 OutData(i).RTaddError(k+m,RT_num(k),j)=ErrorFunction(PencentMistake(3,:),0);
%             end
%         end
%         OutData(i).OutputB([RTASGN_num,RTrandom_num(j,:)],RTMistake,j)=OutData(i).OutputB([RTASGN_num,RTrandom_num(j,:)],RTMistake,j)+OutData(i).RTaddError(:,RTMistake,j);
%         OutData(i).RTaddError(:,end,j)=[RTASGN_num,RTrandom_num(j,:)]';
%     end
% end

end