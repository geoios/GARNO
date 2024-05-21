function INIData = SimulationINISet(w,i0) %
%%Design of sea surface graphic parameters
%Due to the time range of sound velocity profile (2019.7.131:30:17 to 2019.7.15.13:18:26), the start and end times should be within this range.
%Circle (center coordinate XY, radius, angular velocity, angular acceleration, interval time, initial time, end time, deflection angle)
%Rose shaped (center coordinate XY, envelope radius, shape parameters, angular velocity, angular acceleration, interval time, initial time, end time, deflection angle)
%Spiral shape (center coordinate XY, initial radius, angular velocity, angular acceleration, initial pitch, pitch growth rate, pitch growth acceleration, interval time, initial time, end time, deflection angle)
%Line segments (center coordinate XY, velocity, acceleration, interval time, initial time, end time, deflection angle)
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
% Sea surface elevation motion trajectory ([standard random coefficient term, constant term, linear term, sin amplitude term, sin periodic term sin initial phase cos amplitude term, cos periodic term cos initial phase])
INIData.H=[0,0,0];
% Observation interval of underwater stations
INIData.TSecond = 80;
%INIData.TSecond = 20;
%INIData.TSecond = 5;
% Sea surface attitude angle motion trajectory
INIData.AttitudeFun=[0,0.01,0;0,0.01,0;0,0.01,0]; % [E;N;U]
% Arm length parameter
% INIData.Forward = 1.5547;
% INIData.Rightward = -1.2690;
% INIData.Downward = 13.7295;
 INIData.Forward = 1.5547;
 INIData.Rightward = -1.2690;
 INIData.Downward = 13.7295;
% INIData.Forward = 0;
% INIData.Rightward = 0;
% INIData.Downward = 0;
%% Design of Submarine Responder Points
INIData.FloorFrom = 'Customize';    %1.'Customize'; 2.'Polygon'; 3.'Polygon + Customize'
switch INIData.FloorFrom
    case 'Customize'  
        F = SeaBotPFun(1500*sqrt(2)/2,3000,'Centre');
        %F = SeaBotPFun(400*sqrt(2)/2,3010,'Square');%F = SeaBotPFun(1500*sqrt(2)/2,3010,'Square');
        %F = SeaBotPFun(1500*sqrt(2)/2,3000,'Square+Centre');
    case 'Polygon'   
        F = [0,0,4,100,pi/4];
end
%F = [0,0,-3000];
% One S corresponds to a set of points
INIData.FloorMP = F;
% % INIData.TransponderName ={'M01','M02','M03','M04'};
% INIData.TransponderName ={'M01','M02','M03','M04','M05'};
INIData.TransponderName ={'M01','M02','M03','M04','M05'};
% Setting the elevation of seabed points
INIData.h = [0,-3010,0];
INIData.OutPut_FloorRandn = 0;
%% Sound velocity profile correlation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Pre processing of measured sound velocity profiles%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sound velocity profile file address
INIData.SVPFilePath='ProfileData.mat';
% Maximum depth of preprocessed sound velocity profile
INIData.MaxH = 3010;
% Preprocessing sound velocity profile reference time
INIData.LaunchRT=[2019,7,13,21,30,17];
% Stratification strategy for preprocessing sound velocity profile data
INIData.SVPLayerModel = 'Customize';  % 1.'Fix'; 2.'Customize'
switch INIData.SVPLayerModel
    case 'Customize'
        INIData.LayerLag= [10:10:200,250:50:550,600:100:900,1000:400:3000,3010];%[10:10:200,250:50:550,600:100:900,1000:400:3000,3010]; % 指定SVP分层间隔
        %INIData.LayerLag= [10:10:200,250:50:700,765]; % Specify SVP layering interval
    case 'Fix'
        INIData.LayerLag = 10;
end
% Sound velocity profile preprocessing
INIData = SVPresampling(INIData);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Strategy for generating sound velocity profiles%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Sound speed profile mode selection (1. 'SVPAvg' (average sound speed profile); 2. 'EOF' (EOF interpolation sound velocity profile);% 3. 'Constant' (constant sound speed at observation time, sound speed varies at different observation times),
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
        % EOF function (empirical orthogonal function) coefficient A (standard random coefficient term, constant term, linear term, sin amplitude term, sin periodic term sin initial phase cos amplitude term, cos periodic term)
        % In the periodic term, 0.75 represents 0.75 days based on days (initial phase of cos)
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
        % Single layer sound velocity profile model ([standard random coefficient term, constant term, linear term, sin amplitude term, sin period term])
        INIData.MonolayerFun=[0,1490,0,3,1/4];
end

INIData.DouTCalModel = 'Cashing'; % 1.Cashing; 2.GridInter
INIData.SVPRefModel = 'Fix_Munk'; % 1.'Avg'  2.Fix_Munk
%% Accidental | System error addition
% Error coefficient ([standard random coefficient term, constant term, linear term, sin amplitude term, sin period term])
% GNSS antenna error
INIData.CoordianteError=[0;0;0];%[0.05;0.05;0.10]
% Propagation time error
INIData.TimeError=[1*10^-4,0];%[5*10^-5,0];
% Timing error
INIData.TimeSerivceError=[0,0];%[10^-8,0];
% Attitude angle error
INIData.AttitudeError=[0;0;0];%[10^-3;10^-3;10^-3]
% Arm length parameter error
INIData.ATDError=[0;0;0];
% Seabed coordinate point error
INIData.SolidTideError=[0;0;0];

% EOF relative to the average sound speed profile sound speed disturbance test multiple
INIData.EOFCheck = 1;
% EOF projection value PC addition system | accidental error proportion coefficient
INIData.EOFPCPencent = 0;
% EOF projection value PC addition system | accidental error
INIData.EOFPCMistake = [1,0,0,0;1,0,0,0;1,0,0,0;1,0,0,0;1,0,0,0];%[1,0,0,0;1,0,0,0;1,0,0,0;1,0,0,0;1,0,0,0];


% Hardware latency extraction
INIData.HardwareDelay = INIData.TimeError(2);
INIData.TimeError(2) = 0;

% Add position of gross error
% Launch time ([month, day, hour, minute, second, X, Y, Z, Heading, Pitch, Roll])
INIData.STMistake=[6,7,8,9,10,11];
% Receiving time ([month, day, hour, minute, second, label, two-way observation time/2, X, Y, Z, Heading, Pitch, Roll])
INIData.RTMistake=[7,8,9,10,11,12,13];
% Randomly add gross errors proportionally
INIData.EporchPencent=0.00;
% Proportional gross error form ([standard random coefficient term, constant term])
INIData.PencentMistake=[0,0;0,0;0,0];

% Specify launch time ([month, day, hour, minute, second, X, Y, Z, Heading, Pitch, Roll])
INIData.STAMistake=[6,7,8,9];
% Specify acceptance time ([month, day, hour, minute, second, label, two-way observation time/2, X, Y, Z, Heading, Pitch, Roll])
INIData.RTAMistake=[7,8,9,10,11];
% Specify epoch addition (cell array (rows: number of segments, columns: launch and reception time) array (rows: number of seabed points, columns: number of epochs))
for i=1:1:n
    for j=1:2
        EporchAssign{i,j}=[1;1;1;1;1];
    end
end
INIData.EporchAssign=EporchAssign;
% Specify the form of epoch gross error (cell array (rows: number of measurement segments, columns: launch and reception time) array (rows: time, coordinates, attitude, columns: [standard random coefficient term, constant term])
for i=1:1:n
    for j=1:2
        AssignMistake{i,j}=[0,0,0;0,0,0;0,0,0];
    end
end
INIData.AssignMistake=AssignMistake;

%% Save file path
% Data storage address         %% folder with the same name is not case sensitive
INIData.SaveAddress=['Results\BigSquare\SimulationData\'];
% Data output format          %% 1: saving format for sea surface graphics; 2: Save format for sea surface buoys
INIData.Model = 1;
% Do you need to save the structure
INIData.SaveModel = 0;
% Do you want to regenerate the folder
INIData.FileDel = 0;


% Improve the judgment of whether the file exists. If it exists, delete and rebuild it. If it does not exist, create it
str=['.\',INIData.SaveAddress(1:end-1)];
if ~exist(str,'dir')
    mkdir(str)
    oldpath=path;
    path(oldpath,str)
else
    switch INIData.FileDel
        case 1
            rmdir(str,'s') %Delete without going through the recycle bin, use with caution
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

% Save path construction
INIData.SVPaddress=[INIData.SaveAddress,INIData.Campaign,'-svp.csv'];
INIData.Obsaddress=[INIData.SaveAddress,INIData.Campaign,'-obs.csv',];
INIData.Iniaddress=[INIData.SaveAddress,INIData.Campaign,'-initcfg.ini'];
INIData.MatAddress=[INIData.SaveAddress,INIData.Campaign,',mat'] ;
% Save the configuration file to the saved file path
% % Site_name = ['Data'];Cum =17;
% % INIData.Campaign = [Site_name,'.',num2str(Cum)];
% % INIData.FileINIAddress=['./initcfg','/',Site_name,'SimulationData','/',INIData.Campaign,'-initcfg.ini'];
% % INIData.FileSVPAddress=['./obsdata','/',Site_name,'SimulationData','/',INIData.Campaign,'-svp.csv'];
% % INIData.FileOBSAddress=['./obsdata','/',Site_name,'SimulationData','/',INIData.Campaign,'-obs.csv'];
% % 
% % % Save path construction
% % INIData.SVPaddress=[INIData.SaveAddress,INIData.Campaign,'-svp.csv'];
% % INIData.Obsaddress=[INIData.SaveAddress,INIData.Campaign,'-obs.csv',];
% % INIData.Iniaddress=[INIData.SaveAddress,INIData.Campaign,'-initcfg.ini'];
% % INIData.MatAddress=[INIData.SaveAddress,INIData.Campaign,',mat'] ;
end
