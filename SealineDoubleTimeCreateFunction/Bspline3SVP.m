clear;clc;close all
%% 
load('SVPX.mat'); load('SVP1X.mat');load('SVP2X.mat');load('SVP3X.mat');
load('SVPS.mat');load('SVP1S.mat');load('SVP2S.mat');load('SVP3S.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1.读取声速剖面
PF{1} = SVPX;PF{2} = SVPS;PF{3} = SVP1X;PF{4} = SVP1S;
PF{5} = SVP2X;PF{6} = SVP2S;PF{7} = SVP3X;PF{8} = SVP3S;
Step=10;HIGHT=3075;
% 2.将声速剖面进行等间隔处理
Span=Step*ones(ceil(HIGHT/Step),1);
% 三次样条插值进行寻找
[m,n]=size(PF);
for i=1:max(m,n)
    SVP=PF{i};PF{i}=[];
    % 0m处以最近点获取
    H=SVP(:,1);V=SVP(:,2);
    Hight=Span(i):Span(i):HIGHT;
    Speed=interp1(H,V,Hight,'spline');
%     if Hight(end)~=H(end)
%         Hight(end+1)=H(end);
%         Speed(end+1)=V(end);
%     end
    index=find(Hight==2990);
    Findex=index-30;
    NewfitX=Hight(Findex:index);
    NewfitY=Speed(Findex:index);
    [p,~,~,vv]=LSNH(NewfitX,NewfitY,1);
    NewfitHight=Hight(index:end);
    for j=1:length(NewfitHight)
        NewfitSpeed(j)=p(1)*NewfitHight(j)+p(2);
    end
    Speed(index:end)=NewfitSpeed;
    Hight=[0,Hight];Speed=[V(1),Speed];
    PF{i}(:,1)=Hight; PF{i}(:,2)=Speed;
end
NeedData.PF = PF;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
M=size(PF,2);
for i=1:M
plot(PF{i}(:,2),PF{i}(:,1));
hold on 
end
xlabel('声速(m/s)');
ylabel('水深(m)');
set(gca,'YDir','reverse')