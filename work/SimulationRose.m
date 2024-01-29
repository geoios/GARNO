function INIData = SimulationINISet(w,i0) %
%% 海面图形参数设计
% 要求由于声速剖面时间范围（2019.7.13.21:30:17——2019.7.15.13:18:26），因此起止时间应在其内。
% 圆形（中心坐标XY，半径，角速度，角加速度，间隔时间，初始时间，结束时间，偏转角度）
% 玫瑰形（中心坐标XY，包络半径，形状参数，角速度，角加速度，间隔时间，初始时间，结束时间，偏转角度）
% 螺旋形（中心坐标XY，初始半径，角速度，角加速度，初始螺距，螺距增长速度，螺距增长加速度，间隔时间，初始时间，结束时间，偏转角度）
% 线段（中心坐标XY，速度，加速度，间隔时间，初始时间，结束时间，偏转角度）
INIData.SurFrom = 'Roses';  % 1.'Cirlce'; 2.'Roses';  3.'Spirl'; 4.'Segment'
petal = 2;
q = w; % 0.354
%q = 0.45 ;%0.25 0.3 0.4 0.45
%q = sqrt((sqrt(13)-1)/8);1/sqrt(8)
%q = 0.65 ;%0.45 0.5 0.6 0.65
%q = 0.121;
%q = 0.25;
Side=3010/q;
TimeNum=7200;
TNum=80;
V1=pi/3600;
V2=0;
[S]=rose_more(Side,petal,V1,V2,TNum,TimeNum);
n = size(S,1);
INIData.SurMP = S;
INIData.LineNum = n;
INIData.TNum = TNum;
% 海面高程运动轨迹([标准随机系数项，常数项，线性项，sin振幅项，sin周期项 sin初相 cos振幅项，cos周期项 cos初相])
INIData.H=[0,0,0];
% 海底测站观测间隔
INIData.TSecond = 80;
%INIData.TSecond = 20;
%INIData.TSecond = 5;
% 海面姿态角运动轨迹
INIData.AttitudeFun=[0,0.01,0;0,0.01,0;0,0.01,0]; % [E;N;U]
% 臂长参数
% INIData.Forward = 1.5547;
% INIData.Rightward = -1.2690;
% INIData.Downward = 13.7295;
 INIData.Forward = 1.5547;
 INIData.Rightward = -1.2690;
 INIData.Downward = 13.7295;
% INIData.Forward = 0;
% INIData.Rightward = 0;
% INIData.Downward = 0;
%% 海底应答器点位设计
INIData.FloorFrom = 'Customize';    %1.'Customize'; 2.'Polygon'; 3.'Polygon + Customize'
switch INIData.FloorFrom
    case 'Customize'  % 自定义设置
        F = SeaBotPFun(1500*sqrt(2)/2,3000,'Centre');
        %F = SeaBotPFun(400*sqrt(2)/2,3010,'Square');%F = SeaBotPFun(1500*sqrt(2)/2,3010,'Square');
        %F = SeaBotPFun(1500*sqrt(2)/2,3000,'Square+Centre');
    case 'Polygon'   % 正多边形参数（中心坐标X、Y、边数、外接圆半径、旋转角度）
        F = [0,0,4,100,pi/4];
end
%F = [0,0,-3000];
% 一条S对应一组点
INIData.FloorMP = F;
% % INIData.TransponderName ={'M01','M02','M03','M04'};
% INIData.TransponderName ={'M01','M02','M03','M04','M05'};
INIData.TransponderName ={'M01','M02','M03','M04','M05'};
% 海底点高程设置
INIData.h = [0,-3010,0];
INIData.OutPut_FloorRandn = 0;
%% 声速剖面相关
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%实测声速剖面预处理%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 声速剖面文件地址
INIData.SVPFilePath='ProfileData.mat';
% 预处理声速剖面最大深度
INIData.MaxH = 3010;
% 预处理声速剖面基准参考时间
INIData.LaunchRT=[2019,7,13,21,30,17];
% 声速剖面据预处理分层策略
INIData.SVPLayerModel = 'Customize';  % 1.'Fix'; 2.'Customize'
switch INIData.SVPLayerModel
    case 'Customize'
        INIData.LayerLag= [10:10:200,250:50:550,600:100:900,1000:400:3000,3010];%[10:10:200,250:50:550,600:100:900,1000:400:3000,3010]; % 指定SVP分层间隔
        %INIData.LayerLag= [10:10:200,250:50:700,765]; % 指定SVP分层间隔
    case 'Fix'
        INIData.LayerLag = 10;
end
% 声速剖面预处理
INIData = SVPresampling(INIData);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%声速剖面生成策略%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%声速剖面模式选择(1.'SVPAvg'(平均声速剖面)；2.'EOF'(EOF内插声速剖面);%3.'Constant'(观测时刻常声速，不同观测时刻声速不同),
%                 4.'Pseudo-3D',5.'Grid')
INIData.SVPRandom = 'Grid';  %
switch INIData.SVPRandom
    case 'Grid'
        INIData.SVPGridSpan = [500,500,20]; % [E,N,U]
        INIData.SVPGridExt  = [500,500,20]; % [E,N,U]
% %         INIData.SVPGridSpan = [200,200,100]; % [E,N,U]
% %         INIData.SVPGridExt  = [200,200,100]; % [E,N,U]
        INIData.SVPFunction = 'Munk'; % 1.Munk 2.Munk_3D
        INIData.SVPGridModel = 'Munk_Obliquity';
    case 'EOF'
        % EOF函数(经验正交函数)系数A([标准随机系数项，常数项，线性项，sin振幅项，sin周期项 sin初相 cos振幅项，cos周期项
        % cos初相])在周期项上以天为基准，0.75表示0.75天
        INIData.SVPEOFSpdeg = 5;
        for i=1:INIData.SVPEOFSpdeg
            INIData.SVPMP{i,1}=[0,0,0,1,1];
            INIData.SVPMP{i,2}=[0,0,0,1,1/2,pi];
            INIData.SVPMP{i,3}=[0,0,0,1,1/4,pi];
            INIData.SVPMP{i,4}=[0,0,0,1,1/8];
            INIData.SVPMP{i,5}=[0,0,0,1,1/24,pi];
            INIData.SVPMP{i,6}=[0,0,0,1,1/48,pi];
            INIData.CoefficientMatrix(:,i) = [3;2;1;0.5;0.75;0.5];
        end
    case 'Constant'
        % 单层声速剖面模型([标准随机系数项，常数项，线性项，sin振幅项，sin周期项])
        INIData.MonolayerFun=[0,1490,0,3,1/4];
end

INIData.DouTCalModel = 'Cashing'; % 1.Cashing; 2.GridInter
INIData.SVPRefModel = 'Fix_Munk'; % 1.'Avg'  2.Fix_Munk
%% 偶然|系统误差添加
% 误差系数([标准随机系数项，常数项，线性项，sin振幅项，sin周期项])
% GNSS天线误差
INIData.CoordianteError=[0;0;0];%[0.05;0.05;0.10]
% 传播时间误差
INIData.TimeError=[1*10^-4,0];%[5*10^-5,0];
% 授时误差
INIData.TimeSerivceError=[0,0];%[10^-8,0];
% 姿态角误差
INIData.AttitudeError=[0;0;0];%[10^-3;10^-3;10^-3]
% 臂长参数误差
INIData.ATDError=[0;0;0];
% 海底坐标点误差
INIData.SolidTideError=[0;0;0];

% EOF相对于平均声速剖面声速扰动检验倍数,
INIData.EOFCheck = 1;
% EOF投影值PC添加系统|偶然误差比例系数
INIData.EOFPCPencent = 0;
% EOF投影值PC添加系统|偶然误差
INIData.EOFPCMistake = [1,0,0,0;1,0,0,0;1,0,0,0;1,0,0,0;1,0,0,0];%[1,0,0,0;1,0,0,0;1,0,0,0;1,0,0,0;1,0,0,0];


% 硬件延迟提取
INIData.HardwareDelay = INIData.TimeError(2);
INIData.TimeError(2) = 0;

% 粗差添加位置
% 发射时刻([月,日,时,分,秒,X,Y,Z,Heading,Pitch,Roll])
INIData.STMistake=[6,7,8,9,10,11];
% 接收时刻([月,日,时,分,秒,标号,双程观测时间/2,X,Y,Z,Heading,Pitch,Roll])
INIData.RTMistake=[7,8,9,10,11,12,13];
% 按比例随机添加粗差
INIData.EporchPencent=0.00;
% 比例粗差形式([标准随机系数项，常数项])
INIData.PencentMistake=[0,0;0,0;0,0];

% 指定发射时刻([月,日,时,分,秒,X,Y,Z,Heading,Pitch,Roll])
INIData.STAMistake=[6,7,8,9];
% 指定接受时刻([月,日,时,分,秒,标号,双程观测时间/2,X,Y,Z,Heading,Pitch,Roll])
INIData.RTAMistake=[7,8,9,10,11];
% 指定历元添加(胞元数组（行数:测段数，列数:发射、接受时刻）数组（行数:海底点数，列数:历元数）)
for i=1:1:n
    for j=1:2
        EporchAssign{i,j}=[1;1;1;1;1];
    end
end
INIData.EporchAssign=EporchAssign;
% 指定历元粗差形式(胞元数组（行数:测段数，列数:发射、接受时刻）数组（行数:时间、坐标、姿态，列数:[标准随机系数项，常数项]）)
for i=1:1:n
    for j=1:2
        AssignMistake{i,j}=[0,0,0;0,0,0;0,0,0];
    end
end
INIData.AssignMistake=AssignMistake;

%% 保存文件路径
% 数据保存地址            %% 同名文件夹大小写不敏感
INIData.SaveAddress=['Results\BigSquare\SimulationData\'];
% 数据输出格式            %% 1：海面图形保存格式；2：海面浮标保存格式
INIData.Model = 1;
% 是否保存需要保存结构体
INIData.SaveModel = 0;
% 是否重新生成文件夹
INIData.FileDel = 0;


% 完善判断文件是否存在，如果存在删掉重建，不存在，创建
str=['.\',INIData.SaveAddress(1:end-1)];
if ~exist(str,'dir')
    mkdir(str)
    oldpath=path;
    path(oldpath,str)
else
    switch INIData.FileDel
        case 1
            rmdir(str,'s') %该删除不经过回收站，慎重使用
            mkdir(str)
            oldpath=path;
            path(oldpath,str)
    end
end
Site_name = ['Data'];p = w;Cum = i0;
INIData.Campaign = [Site_name,'.','SimulationData',num2str(p),'-',num2str(Cum)];
INIData.FileINIAddress=['./initcfg','/',Site_name,'/',INIData.Campaign,'-initcfg.ini'];
INIData.FileSVPAddress=['./obsdata','/',Site_name,'/',INIData.Campaign,'-svp.csv'];
INIData.FileOBSAddress=['./obsdata','/',Site_name,'/',INIData.Campaign,'-obs.csv'];

% 保存路径构建
INIData.SVPaddress=[INIData.SaveAddress,INIData.Campaign,'-svp.csv'];
INIData.Obsaddress=[INIData.SaveAddress,INIData.Campaign,'-obs.csv',];
INIData.Iniaddress=[INIData.SaveAddress,INIData.Campaign,'-initcfg.ini'];
INIData.MatAddress=[INIData.SaveAddress,INIData.Campaign,',mat'] ;
% 配置文件存入保存的文件路径
% % Site_name = ['Data'];Cum =17;
% % INIData.Campaign = [Site_name,'.',num2str(Cum)];
% % INIData.FileINIAddress=['./initcfg','/',Site_name,'SimulationData','/',INIData.Campaign,'-initcfg.ini'];
% % INIData.FileSVPAddress=['./obsdata','/',Site_name,'SimulationData','/',INIData.Campaign,'-svp.csv'];
% % INIData.FileOBSAddress=['./obsdata','/',Site_name,'SimulationData','/',INIData.Campaign,'-obs.csv'];
% % 
% % % 保存路径构建
% % INIData.SVPaddress=[INIData.SaveAddress,INIData.Campaign,'-svp.csv'];
% % INIData.Obsaddress=[INIData.SaveAddress,INIData.Campaign,'-obs.csv',];
% % INIData.Iniaddress=[INIData.SaveAddress,INIData.Campaign,'-initcfg.ini'];
% % INIData.MatAddress=[INIData.SaveAddress,INIData.Campaign,',mat'] ;
end