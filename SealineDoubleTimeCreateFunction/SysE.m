function S = SysE(i,C,Amplitude,Initial_appearance,sig)



T_max = 365 * 24 * 60 * 60;
a1    = Amplitude(1);%% m
th1   = Initial_appearance(1);
S1 = a1 * cos(2*pi/T_max * i  + th1);
%%%%半年周期
T_Sem = T_max/2;
a2    = Amplitude(2);%% m
th2   = Initial_appearance(2);
S2 = a2 * cos(2*pi/T_Sem * i  + th2);
%%%%季节周期
T_J = T_max/4;
a3    = Amplitude(3);%% m
th3   = Initial_appearance(3);
S3 = a3 * cos(2*pi/T_J * i  + th3);

%%%%天周期
T_D = T_max/365;
a4    = Amplitude(4);%% m
th4   = Initial_appearance(4);
S4 = a4 * cos(2*pi/T_D * i  + th4);
SS4(i) = S4;
%%%%半天周期
T_SD = T_max/365/2;
a5    = Amplitude(5);%% m
th5   = Initial_appearance(5);
S5 = a5 * cos(2*pi/T_SD * i  + th5);
%%%%小时周期
T_H = T_max/365/24;
a6    = Amplitude(6);%% m
th6   = Initial_appearance(6);
S6 = a6 * cos(2*pi/T_H * i  + th6);
%%%% 1分钟为周期（波浪）
T_M = T_max/365/24/60;
a7    = Amplitude(7);%% m
th7   = Initial_appearance(7);
S7 = a7 * cos(2*pi/T_M * i  + th7);
S = C + S1 + S2 + S3 + S4 + S5 + S6 + S7 + sig * randn(1);
