function [AllHouS,DayS,Es,SysEDis,GDOP11,GDOP22] = AddError_ComputeHourlySolution( X,x,TStart,TEnd,ConstantError,Amplitude,InitialAppearance,GaussianNoise  )
N = size(X,1); %%X 的行数
n = size(x,1); %%x 的行数
%% 计算循环周期
[ DayEnd,HourEnd,SecondEnd ] = ComputePeriod( TStart,TEnd );

%% %%模拟观测误差#######
%%%%           %%%%%%%
%假设最大的周期为年周期
delat = 0.0001;
Es = [];
SysEDis=[];
DayS=zeros(DayEnd,3);
AllHouS = zeros(fix((TEnd-TStart)/3600),3);

%% 计算海面点和海底应答器之间几何距离
for j=1:n
    for i=1:N
        Dis(j,i) = norm(X(i,:) - x(j,:));
    end
end

%% 生成周期距离误差+换能器与应答器之间距离，利用误差观测方程实现迭代计算海底点坐标
for j = 1:DayEnd
    j
    tic
    if j==DayEnd
        hourEnd=HourEnd;
    else
        hourEnd=24;
    end
    for k = 1 : hourEnd
        if j==DayEnd && k==HourEnd
            secondEnd=SecondEnd;
        else
            secondEnd=3600;
        end
        dis=Dis(:,(j-1)*24*3600+(k-1)*3600+1:(j-1)*24*3600+(k-1)*3600+secondEnd);
        parfor i = 1 : secondEnd
            time = TStart+(j-1)*24*3600+(k-1)*3600+i;
            SysError(i)= SysE(time,ConstantError,Amplitude,InitialAppearance,GaussianNoise);
        end
        Es=[Es SysError];
        S=[];
        for ii=1:n
            parfor i = 1 : secondEnd
                S(i,ii) = dis(ii,i) + SysError(i);
                %Es =  [Es;Sys1(1:10:3600)];
            end
        end
        SysEDis=[SysEDis;S];
        P0=eye(secondEnd);
        for i=1:n
            %%% 小时解时间序列
            XX=X((j-1)*24*3600+(k-1)*3600+1:(j-1)*24*3600+(k-1)*3600+secondEnd,:);
            s=S(:,i);xx=x(i,:);
            [x_LS]  = NonLinearLS_Robust(XX,s,xx,delat);   %%%传统最小二乘
            
            %[x_LS]  =  GaussNewton(XX,s,[xx 0]',delat,1);   %%%传统最小二乘
            
            HouS(k,:,i) = x_LS;
            AllHouS((j-1)*24 + k,:,i) = x_LS;
            
            %%% 每个小时的GDOP
            [GDOP11((j-1)*24+k,i),A] = GDOP1(xx,XX');
            %[GDOP22((j-1)*24+k,i) A] = GDOP2(xx,XX');
            QQx = inv(24^2 * A' * A);
            GDOP22((j-1)*24+k,i) = QQx(1,1) + QQx(2,2);
        end
    end
    for i=1:n
        DayS(j,:,i) = mean(HouS(:,:,i));  %% 每列平均值
    end
    toc
end
end

