function [E,N,U] = BLH_XYZ2ENU(B_scv,L_scv,X_rcv,Y_rcv,Z_rcv,X_scv,Y_scv,Z_scv)
% s发射源 r接收端
% BLH 矩阵

BLH = [-sin(L_scv)           ,cos(L_scv)            ,0
       -sin(B_scv)*cos(L_scv),-sin(B_scv)*sin(L_scv),cos(B_scv)
        cos(B_scv)*cos(L_scv),-sin(B_scv)*sin(L_scv),sin(B_scv)];

% XYZ 矩阵
XYZ = [X_rcv - X_scv; Y_rcv - Y_scv; Z_rcv - Z_scv];

% 局部坐标系
ENU = BLH * XYZ;
E = ENU(1);N = ENU(2);U = ENU(3);
end

