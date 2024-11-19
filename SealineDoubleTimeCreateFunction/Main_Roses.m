close all; clear all; clc
a = 2000
k = 2
k1 = 4
k2 = 3

%%%  1秒采样率，完成整个图形，即1小时完成观测
if k/2 == fix(k/2)
   delt = pi/1800
else
   delt = pi/3600
end
[theta rho X] = RosesConfig(a,k,delt,k1,k2);

% h = polar(theta,rho)
% figure(1);
% set(h,'color',[1,0,0],'LineWidth',2)

%%%每个小时的GDOP
X(:,3) = 0;
n = size(X,1);
h = 4000;
x = [0 0 h];
[GDOP11 A] = GDOP1(x,X');
[GDOP22 A] = GDOP2(x,X');
A' * A;

%%%%假设玫瑰曲线的重复周期为 1 hour-->[0 2pi] or [0 pi],对应余弦曲线cos(ka)。
%%%% 小于1小时的信号包括5分钟，

%%%%模拟观测误差#######
%%%%           %%%%%%%
%假设最大的周期为年周期
delat = 0.0001;
Es = [];
DayS=zeros(365,4);
AllHouS = zeros(365*24,4);
for i=1:3600
    Dis(i) = norm(X(i,:) - x);
end
for j = 1:365
    j
    for k = 1 : 24
        parfor i = 1 : 3600
            time = (j-1) * 24 * 3600  + (k-1) * 3600 + i;
            S(i,:) = Dis(i) + SysE(time,0.05);
            %Es =  [Es;Sys1(1:10:3600)];
        end
        %%% 小时解时间序列
        %[x_LS dL Aalf sig1]  = NonLinearLS_Robust(X,S,x,delat);   %%%传统最小二乘

        [x_LS]  =  GaussNewton(X,S,[x 0]',delat,1);   %%%传统最小二乘
       
        HouS(k,:) = x_LS;
        AllHouS((j-1)*24 + k,:) = x_LS;
    end
    DayS(j,:) = mean(HouS);
end
save('DaySs.mat');
save('AllHouS.mat');
save('Es.mat');
