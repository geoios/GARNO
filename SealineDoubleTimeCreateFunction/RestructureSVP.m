function [NewSVP] = RestructureSVP(T,INIData)
PF = INIData.SubProfile;
%% 求解声速场均值、去中心化声速场和特征向量以及修正系数矩阵
% 选取声速剖面最少的层数为基准构建EOF所需声速剖面矩阵
SoundVMatrix = [];
for i=1:length(PF)
    SoundVMatrix = [SoundVMatrix,PF{i}(1:end,2)];
end
SVPAvg=mean(SoundVMatrix,2);
SoundVMatrix=SoundVMatrix-SVPAvg(:,ones(length(PF),1));
[~,S,V]=svd(SoundVMatrix*SoundVMatrix'./INIData.SVPLayer,0);
PC=V\SoundVMatrix;
% Ssquare=diag(S).^2;
% CR=0;CRS=sum(Ssquare);
% for i=1:num
%     CR=CR+Ssquare(i,1);
%     contributionRate=CR/CRS;
%     if contributionRate>=ContributionRate
%         Degree=i;
%         break;
%     elseif i>=7
%         Degree=6;
%         break
%     end
% end
%% 根据声速剖面的时间计算系数阵
% 由给定时间的声速剖面观测时间求解
EOFPCMistake=INIData.EOFPCMistake;EOFPCPencent=INIData.EOFPCPencent;
% for i=1:length(INIData.A)
%     A=INIData.A{i};
%     CoefficientMatrix(:,i)=pinv(A'*A)*(A'*PC(i,:)');
% end
% 指定周期变化
CoefficientMatrix=INIData.CoefficientMatrix;
%
EOFA=INIData.SVPMP;
for i=1:length(INIData.A)
NewA=[];
    for j=1:size(INIData.A{i},2)
        NewA(j)=ErrorFunction(EOFA{i,j},T);
    end
    NewPC(i)=NewA*CoefficientMatrix(:,i);
end
NewPC=NewPC';

for i=1:1:length(NewPC)
    EOFPCMistake(i,:)=EOFPCMistake(i,:)*NewPC(i)*EOFPCPencent;
end
NewPC=NewPC+[ErrorFunction(EOFPCMistake(1,:),T),ErrorFunction(EOFPCMistake(2,:),T),...
    ErrorFunction(EOFPCMistake(3,:),T),ErrorFunction(EOFPCMistake(4,:),T),ErrorFunction(EOFPCMistake(5,:),T)]';

NewF = V(:,1:size(EOFA,1));
EOFCheck = INIData.EOFCheck;
NewSVP=SVPAvg + EOFCheck * NewF * NewPC;
NewSVP=[PF{1}(1:end,1),NewSVP];
end

