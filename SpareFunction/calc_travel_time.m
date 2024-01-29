function [travel_time] = calc_travel_time(t_angle, nl, layer_d, layer_s, sv_d, sv_s, y_d, y_s, l_dep, l_sv, l_sv_trend, l_th)
%CALC_TRAVEL_TIME 此处显示有关此函数的摘要
%    输入参数：入射角 、声速剖面层数、应答器所在深度层、换能器所在深度层、应答器所在深度的声速、换能器所在深度的声速、
%   海底应答器坐标U方向坐标、海面换能器坐标U方向坐标、深度list、声速list、声速变化率l_sv_trend、深度变化率

% 先验参数
lmax=55;epg=10^-2;
eang=80*pi/180;
epr=10^-12;
epa=sin(eang);
travel_time = 0.0;
pp = sin(t_angle)/sv_d;  %% sin(theta)/海底声速=pp
tinc = 0.0;

%%.0
if y_d~=y_s
    k1=layer_s-1;  % k1=换能器深度层-1
    vn=zeros(1,layer_d);tn=zeros(1,layer_d);
    % vn 读取节点声速列表（初始节点换能器，终止节点应答器）
    vn(k1+1:layer_d-1) = l_sv(k1+1:layer_d-1);  
    vn(k1)      = sv_s;
    vn(layer_d) = sv_d;
    % tn  每层深度变化（初始换能器，终止应答器）
    tn(layer_s:layer_d) = l_th(layer_s-1:layer_d-1);
    tn(layer_s) = tn(layer_s) - (y_s - l_dep(k1));
    tn(layer_d) = tn(layer_d) - (l_dep(layer_d) - y_d);
    
    for i=layer_s:1:layer_d
        j=i-1;
        % sn1下层节点的sin(入射角)；sn2上层节点的sin(入射角)；cn cos(入射角)
        sn1 = pp*vn(i);
        cn1 = sqrt(1.0 - sn1^2);
        sn2 = pp*vn(j);
        cn2 = sqrt(1.0 - sn2^2);
        
        if abs(l_sv_trend(i-1))>epg
            tinc=(log((1.0+cn2)/(1.0+cn1))+log(vn(i)/vn(j)))/l_sv_trend(i-1);
        elseif abs(l_sv_trend(i-1))<=epg
            snm=min(sn1,sn2);
            if (snm>epa)
                aatra=1.0;bbtra=1.0;
                cctra=cn1*(cn2+cn1);
                d2=cn2^2;
                d1=cn1^2;
                tmp=0;ls=1;
                while 1
                    tmpdd=aatra/ls;
                    tmp=tmp+tmpdd;
                    if (tmpdd>=epr && ls<=lmax)
                        aatra=aatra*d2+bbtra*cctra;
                        bbtra=bbtra*d1;
                        ls=ls+2;
                        continue;
                    else
                        tinc=tn(i)*tmp*pp*(sn1+sn2)/(cn1+cn2);
                        break;
                    end
                end
            elseif (snm<=epa)
                zzc = pp*(sn1 + sn2)/(1.0 + cn1)/(cn1 + cn2);
                xxc = 1.0/vn(i);
                zz = (cn1 - cn2)/(1.0 + cn1);xx = xxc*(vn(i) - vn(j));
                za = 1.0;xa = 1.0;tmp = 0.0;ls = 1 ;
                
                while 1
                    tmpdd=(za*zzc+xa*xxc)/ls;
                    tmp=tmp+tmpdd;
                    if (tmpdd>=epr && ls<=lmax)
                        za=za*zz;
                        xa=xa*xx;
                        ls=ls+1;
                        continue;
                    else
                        tinc=tn(i)*tmp;
                        break;
                    end
                end
            end
        end
        travel_time = travel_time + tinc;
    end
end
end

