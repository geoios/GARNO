function [X,Y,Z] = BLH2XYZ(B,L,H,a,b)

% 模型扁率e
e2 = (a^2-b^2)/a^2;
% 质点垂直曲率半径
N = a/sqrt(1-e2*sin(B)^2);

% 地心地固坐标（ECEF）
X = (N + H) * cos(B) * cos(L);
Y = (N + H) * cos(B) * sin(L);
Z = (N * (1 - e2) + H) * sin(B);

end

