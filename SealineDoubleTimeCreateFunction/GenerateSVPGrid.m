function [ProcessData] = GenerateSVPGrid(INIData,ProcessData,OutData)

%% 1.建立声速空间网
% 获取 海面-海底控制网最大边界范围（设定声速空间网范围）
GridSpan = INIData.SVPGridSpan;SVPGridExt = INIData.SVPGridExt;
ExtremeValRanDer = ProcessData.ExtremeValRanDer;
ExtremeValRanCer = ProcessData.ExtremeValRanCer;
GridEgdeMin = min([ExtremeValRanDer(1:3);ExtremeValRanCer(1:3)],[],1);
GridEgdeMax = max([ExtremeValRanDer(4:6);ExtremeValRanCer(4:6)],[],1);
GridExtremeValRan =[GridEgdeMin,GridEgdeMax];
% 构建地球椭球面
% 生成三维空间格网,生成对应点声速值
x = GridExtremeValRan(1) - SVPGridExt(1):GridSpan(1):GridExtremeValRan(4) + SVPGridExt(1);
y = GridExtremeValRan(2) - SVPGridExt(2):GridSpan(2):GridExtremeValRan(5) + SVPGridExt(2);
z = GridExtremeValRan(3) - SVPGridExt(3):GridSpan(3):GridExtremeValRan(6) + SVPGridExt(3);
GridArray = zeros(length(x),length(y),length(z));
%% 水平梯度随深度变化
%GradE = logspace(-6,-4,length(z));
%GradE1 = logspace(-6,-4,length(z)/3);  % 非线性
% % GradE2 = logspace(-4,-6,length(z)/3); 
% % GradE3 = logspace(-6,-4,102); 
%GradE = linspace(0,0.0001,length(z)); 
% % GradE2 = linspace(0.0001,0,length(z)/3); 
% % GradE3 = linspace(0,0.0001,length(z)/3); 
% % GradE=[GradE1 GradE2 GradE3];
% % plot([GradE1 GradE2 GradE3],z,'b');
% % grid on
% %GradE = linspace(0,0.00005,length(z));  % 线性
% % a1=[GradE(302)+GradE(297)]*50/2/50;
% % a3=[GradE(292)+GradE(287)]*50/2/50;
% % a=ones(60,1);
% % for i = 1:60
% %     a(i)= [GradE(302-(i-1)*5)+GradE(302-i*5)]*50/2/50;
% % end
%% 填充图绘制
% GradE = linspace(0,0.0001,length(z));
% % % % % GradE = ones(1,length(z));
% % % % % % % GradE(:) = 0.0001;
% % plot(GradE,z,'b');
% % xlabel('水平梯度(m/s/m)');
% % ylabel('深度(m)');
% % set(gca,'FontSize',14)
% % ax = gca;
% % ax.XAxisLocation = 'top';
% % grid on
% % ylim([-3000,0]);
% % xlim([0,0.0001]);
% % hold on
% % maxY = max([GradE; z]); 
% % minY = min([GradE; z]); 
% % yFill = [maxY, fliplr(minY)];
% % xFill = [GradE, fliplr(GradE)];  % fliplr函数：左右翻转
% % fill(xFill, yFill, 'c');
%% 填充图绘制
% % x=[0,0,0.0001,0.0001];
% % y=[0,-500,-500,0];
% % fill(x, y, 'c');
% % xlabel('水平梯度(m/s/m)');
% % ylabel('深度(m)');
% % ax = gca;
% % ax.XAxisLocation = 'top'; 
% % ylim([-3000,0]);
% % xlim([0,0.0001]);
%%
% % % % grid on
% bbb=mean(GradE);
%plot(GradE,z)
% ccc=0.0005*3010*0.5/3010
%% 不同层加入水平梯度
GradE = ones(length(z),1);
GradE(:) = 0.0001;
%1200-1500m
GradE(1:116) = 0;
% % %900-1200m
%GradE(32:61) = 0.0001;
% % %600-900m
% % GradE(62:91) = 0.0001;
% % %300-600m
%%GradE(92:121) = 0.0001;
% % %0-300m
% % GradE(122:155) = 0.0001;
% % %%%%  300m分层

% % GradE(242:271) = 0.00006;
% % GradE(212:241) = 0.00004;
% % GradE(182:211) = 0.00002;
% % GradE(152:181) = 0;
% % GradE(122:151) = 0.00002;
% % GradE(92:121) = 0.00004;
% % GradE(62:91) = 0.00006;
% % GradE(32:61) = 0.00008;
% % GradE(1:31) = 0.0001;
% bb=mean(GradE);
% % % % GradN = 0 %linspace(0,0.00005,length(z));
%% 常声速

%% 
switch INIData.SVPGridModel
    case 'Munk_Sphere'
        for i = 1:length(z)
            for j = 1:length(y)
                for k = 1:length(x)
                    C = GenerateMunk_XYZ(x(k),y(j),z(i),1300,min(z),INIData.SVPFunction,'Yes');              
                    GridV{k,j,i} = [x(k),y(j),z(i),C];
                    GridArray(k,j,i) = C;
                    %             scatter3(GridV{k,j,i}(1),GridV{k,j,i}(2),GridV{k,j,i}(3),12,GridV{k,j,i}(4),'filled');
                    %             hold on
                end
            end
        end
    case 'Munk_Obliquity'
        for i =  1 :length(z)
            for j = 1:length(y)
                for k = 1:length(x)
                    %C = GenerateMunk_XYZ(x(k),y(j),z(i),1300,min(z),INIData.SVPFunction,'Yes');
%                     C =   0.00003*y(j)  %C+ GradE(i)*y(j);

            v0 = 1500; % 地面处声速，单位：m/s
            a = 0.005;  % 声速随高度变化率，单位：m/s/m
            v = v0 + a * z(i);

                    C =  v + 0.00004*y(j);  %C+ GradE(i)*y(j);%%%%%%%%%%%%%加声速梯度
                    GridV{k,j,i} = [x(k),y(j),z(i),C];
                    GridArray(k,j,i) = C;
% %                     scatter3(GridV{k,j,i}(1),GridV{k,j,i}(2),GridV{k,j,i}(3),12,GridV{k,j,i}(4),'filled');
% %                     hold on
                end
            end
        end
end
ProcessData.Gridx = x;ProcessData.Gridy = y;ProcessData.Gridz = z;
ProcessData.GridV = GridV;
% 
% 
% % FigSet.FontSize = 18;
% % hXLabel = xlabel('\fontname{Times new roman}{E(m)}','FontSize',FigSet.FontSize);
% % hYLabel = ylabel('\fontname{Times new roman}{N(m)}','FontSize',FigSet.FontSize);
% % hYLabel = zlabel('\fontname{Times new roman}{U(m)}','FontSize',FigSet.FontSize);
% % h = colorbar();
% % set(get(h,'Title'),'string','声速:m/s','fontsize',18,'linewidth',1.5);

%% 2.构建观测时刻声速剖面
Num = 1;
for n = 1:INIData.LineNum
    for m = 1:INIData.TransponderNum
        FloorP = ProcessData.Transponder_ENU(m,:);
        num = ProcessData.LineObsNumList(n,m);
        for k = 1:num
            SurPonit = OutData(n).Transducer_ENU_ST(k,:,m);
            % (1) 简单的表示为两点之间的连线上的声速值
            % 比值法确定X,Y,Z坐标
            RayTrialPZ = INIData.SVPLayerH ;
            K = (-RayTrialPZ - SurPonit(3))/(FloorP(3)-SurPonit(3));
            RayTrialPX = K * (FloorP(1)-SurPonit(1)) + SurPonit(1);
            RayTrialPY = K * (FloorP(2)-SurPonit(2)) + SurPonit(2);            
            Speed_List= interpn(x,y,z,GridArray,RayTrialPX,RayTrialPY,-RayTrialPZ,'liner');
            SSP = [RayTrialPZ,Speed_List];
            T = ProcessData.ST_ObsSec(k,m,n);
            SVP{k,m,n} = PFGrad(SSP,2,1);
            SVPSpeedList(:,Num) = SSP(:,2);
            Num = Num + 1;
        end
    end
end
ProcessData.SVP = SVP;
switch INIData.SVPRefModel
    case 'Fix_Munk'
            v0 = 1500; % 地面处声速，单位：m/s
            a = 0.005;  % 声速随高度变化率，单位：m/s/m
            v = v0 + a * (-INIData.SVPLayerH);%+ 0.00005;
        
        SSPRef_H = v;%GenerateMunk_XYZ([],[],-INIData.SVPLayerH,1300,[],'Munk');
        ProcessData.SVPRef = [INIData.SVPLayerH,SSPRef_H];
    case 'Avg'
        ProcessData.SVPRef = [INIData.SVPLayerH,mean(SVPSpeedList,2)];
end
end

