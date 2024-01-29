close all; clear; clc;close("all");
%% 获取当前脚本的位置
ScriptPath      = mfilename('fullpath');      % 脚本位置
[FilePath] = fileparts(ScriptPath);      % 文件夹位置
cd(FilePath);
clear FilePath;

%% 海面图形绘制
Color={'ro','b*','k.','ys','g.','c.','m.','k.'};
for j=1:8
    for i=1:5
        a=plot(OutData(j).Transducer_ENU_ST(:,1,i),OutData(j).Transducer_ENU_ST(:,2,i),Color{i});%
        hold on
        c=plot(OutData(j).Transducer_ENU_RT(:,1,i),OutData(j).Transducer_ENU_RT(:,2,i),Color{i+1});%
    end
end

b = plot(ProcessData.Transponder_ENU(:,1),ProcessData.Transponder_ENU(:,2),'sr','MarkerFaceColor','r','MarkerSize',8);
legend(b,{'应答器'})
FigSet.FontSize = 12;
hXLabel = xlabel('\fontname{Times new roman}{\itE(m)}','FontSize',FigSet.FontSize);
hYLabel = ylabel('\fontname{Times new roman}{\itN(m)}','FontSize',FigSet.FontSize);
grid on 


%% 
x1 = 1:100;
x2 = (1:50)';
x3 = 1:30;

V = rand(100,50,30);
xq1 = [1 4 7];
xq2 = [2 5 35];
xq3 = [3 56 35];
vq = interpn(x1,x2,x3,V,xq1,xq2,xq3,'linear',-1)


%% WGS84 椭球绘制
[X,Y,Z] = ellipsoid(0,0,0,xr,yr,zr)



%% 绘制Munk剖面
figure()
SVP_H = [10:10:200,250:50:550,600:100:900,1000:400:3000,3065];
Cz = 1300;
Z_Est = 2*(SVP_H - Cz)/Cz;
C = 1500*(1+0.00737*(Z_Est-1+exp(-Z_Est)));


plot(C,SVP_H,'-b');

set(gca,'YDir','reverse');






%% 声速剖面绘制
figure(19)
QQ=jet(8);
SubP = INIData.SubProfile;
n=length(SubP);
for i = 1:n
    SubSVP = SubP{i};
    SVP_ini_List(:,i) =  SubSVP(:,2);
end
SVP_ini = mean(SVP_ini_List,2);


for j=1:n
    SubSVP=SubP{j};
    dSVP=SubSVP(:,2) - SVP_ini;
    a=plot(SubSVP(:,2),SubSVP(:,1),'LineWidth',1.5,'Color',QQ(j,:));
    hold on
end
grid on
set(gca,'YDir','reverse');
FigSet.FontSize=18;
FigSet.Name1=['2019年南海实测声速变化'];
hTitle = title(FigSet.Name1,'FontSize',FigSet.FontSize);
hXLabel = xlabel('\fontname{宋体}{\it声速变化值}\fontname{Times new roman}{\it(m/s)}','FontSize',FigSet.FontSize);
hYLabel = ylabel('\fontname{宋体}{\it深度}\fontname{Times new roman}{\it(m)}','FontSize',FigSet.FontSize);
FigSet.PaperPosition=[0,0,20,10];
set(gcf, 'PaperPosition', FigSet.PaperPosition);
% 指定figure的尺寸
FigSet.Size=[0,0,20,15];
set(gcf,'unit','centimeters','position',FigSet.Size);
% 改变ylabel离坐标轴的距离
set(findobj('FontSize',10),'FontSize',FigSet.FontSize);
h=legend({'13.22:11','13.23:26','14.14:02','14.15:43','15.00:25','15.01:21','15.12:52','15.13:51'});
set(h,'FontName','Times New Roman','FontSize',FigSet.FontSize,'Location','best');
% axis([1480 1550 0 3500])