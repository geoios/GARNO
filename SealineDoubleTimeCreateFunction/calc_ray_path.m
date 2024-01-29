function [t_ag,t_tm] = calc_ray_path(distance,y_d,y_s,l_depth,l_sv,nlyr)
%CALC_RAY_PATH 此处显示有关此函数的摘要
%   两端水平距离、较深端的高度（深度）、较浅端高度（深度）、每个节点的深度、每个节点的声速、声速剖面的节点数 

%   设置先验参数（loop1为入射角二分法的寻找迭代最大迭代次数；loop2=）
loop1=200;loop2=20;
eps1=10^-7;eps2=10^-14;

%% 声速层的设置梯度和厚度
layer_thickness=l_depth(2:nlyr)-l_depth(1:nlyr-1); % 声速层厚度
layer_sv_trend=(l_sv(2:nlyr)-l_sv(1:nlyr-1))./layer_thickness; % 声速垂直梯度=（上层声速-下层声速）/声速层厚度
%% 设置层号和两端的声速
% 确定海面换能器、海底应答器所在的 剖面层号 和 声速
[sv_d, layer_d]=layer_setting(nlyr,y_d,l_depth,l_sv,layer_sv_trend); %海底
[sv_s, layer_s]=layer_setting(nlyr,y_s,l_depth,l_sv,layer_sv_trend); %海面
%% 起飞角度粗扫
x_hori=0;r_nm=0;
tadeg=[0,20,40,60,80,80];
ta_rough=pi*(180-tadeg)/180;        % sin(pi-x)=sin(x)
for i=1:5
    if i==5
        break;
    end
    j=i+1;
    %% 计算给定入射角（ta_rough(j)）的水平距离（x_hori）、射线长度（a0）
    [x_hori(j),a0]=ray_path(ta_rough(j),nlyr,layer_d,layer_s,sv_d,sv_s,y_d,y_s,l_depth,l_sv); 
    % 输出水平距离和路径长度
    % negative distance does not make sense             负距离没有意义
    if x_hori(j)<0
        continue;
    end
    
    % Only if x_hori(i) <= distance <= x_hori(i+1),     仅当x_hori(i) <= distance <= x_hori(i+1)
    % takeoff angle should be between ta_rough(i) and ta_rough(i+1) 起飞角应在ta_rough(i)与ta_rough(i+1)之间
    diff1=distance-x_hori(i);
    diff2=x_hori(j)-distance;
    if diff1*diff2<0
        continue;
    end
    r_nm=1;
    x1=x_hori(i);x2=x_hori(j);
    t_angle1=ta_rough(i);t_angle2=ta_rough(j);
    % 详细搜索起飞角（转换标准为“eps1”）
    % 是用二分法求解最佳入射角
    for k=1:loop1
        x_diff=x1-x2; % 两条路径的水平差异
        if(abs(x_diff)<eps1)
            break;
        end       
        % 计算平均起飞角（t_angle0）的水平距离（x0）
        % x0应为x1或x2（取决于x0距离的符号）
        t_angle0 = (t_angle1 + t_angle2)/2;
        [x0, a0]=ray_path(t_angle0, nlyr, layer_d, layer_s, sv_d, sv_s, y_d, y_s, l_depth, l_sv);% 输出水平距离和路径长度
        a0 = -a0;
        t0 = distance - x0;
        if t0*diff1 > 0.0
            x1 = x0;
            t_angle1 = t_angle0;
        else
            x2 = x0;
            t_angle2 = t_angle0;
        end
    end
    
    diff_true0=abs((distance - x0)/distance); % 近似为相对误差
    
    for k=1:loop2
        % delta_angle 弧长的角度（x0-距离）
        delta_angle = (distance - x0)/a0 ; % (坐标计算距离与声速剖面拟算距离)/射线路径的长度
        t_angle = t_angle0 + delta_angle; % 最适入射角度+上式
        % 检查收敛（“eps2”）
        
        if(abs(delta_angle) <eps2)
            break;
        end
        
        [x0, a0]=ray_path(t_angle, nlyr, layer_d, layer_s, sv_d, sv_s, y_d, y_s, l_depth,l_sv);
        a0 = -a0;
        
        diff_true1 = abs((distance - x0)/distance);
        if(diff_true0 <= diff_true1)
            t_angle = t_angle0;
            break;
        end
        % 检查收敛（“eps2”）
        if(diff_true1 < eps2)
            break;
        end
    end
    break;
end

if r_nm==0
    disp('Distance:%d\tX_hori:%d\t TA_rough:%d\tDepth,Sound Speed',distance,x_hori,ta_rough);
end
t_ag = t_angle;
t_tm=calc_travel_time(t_angle,nlyr,layer_d,layer_s,sv_d,sv_s,y_d,y_s,l_depth,l_sv,layer_sv_trend,layer_thickness);
end
