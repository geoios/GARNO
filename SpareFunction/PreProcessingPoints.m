function [S,R] = PreProcessingPoints(S,R)

% The z coordinates of points are negtive in the local coordinate system 点的z坐标在局部坐标系中为负
if S(3) < 0; S(3) = -S(3); end
if R(3) < 0; R(3) = -R(3); end

% when processing the seafloor points, the sound source may be from the bottom  处理海底点时，声源可能来自海底
if R(3) < S(3)
    %warndlg('end depth < start depth ! two points have been exchanged'); 警告（'结束深度<开始深度！交换了两点坐标'；
    R0 = R; R = S; S = R0;
end