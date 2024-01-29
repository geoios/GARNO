function [sv,layer_n] = layer_setting(nlyr, depth, l_depth, l_sv, l_sv_trend)
%LAYER_SETTING 此处显示有关此函数的摘要 “sv”是“depth”处的声速
%   传入参数：声速剖面层数 海底应答器/海面换能器坐标U方向坐标 深度list 声速list 声速变化率 

for i=2:1:nlyr
    if l_depth(i)>=depth
        layer_n=i;
        break;
    end
end
if i==nlyr+1
    disp('b %d\t%d',depth,l_depth);
end
% sv = 应答器所在声速层声速+（应答器深度-应答器所在声速层深度）*声速变化率
sv=l_sv(layer_n)+(depth-l_depth(layer_n))*l_sv_trend(layer_n-1);

end

