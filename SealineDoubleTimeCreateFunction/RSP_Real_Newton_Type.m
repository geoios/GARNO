function [x0 k QQ sig0_2 dL xx] = RSP_Real_Newton_Type(X,L,x0,P0,p,type,delt,flag,P)
%%
% X 控制点坐标
% L 距离观测
% x0 初值
% P0 观测权
% p 范数，p=2为最小二乘，p=1为1范数估计，一般取1<p<2
% type方法，type=0为高斯牛顿法，type=1为牛顿法(封闭)
% delt 迭代误差
% flag:0 无钟差
%      1 含钟差
% P 先验信息x0的权
[n m]=size(X);
Pior = x0;
k=0;
xx=[];
while (1)
    if flag == 0
        for i = 1 : n
            dif    = X(i,:) - x0';
            dis    = norm(dif);
            A(i,:) = dif./dis;
            dL(i)  = dis - L(i);
            
            abs_v = abs(dL(i));
            if abs_v<0.0001
            abs_v = 0.0001;
            end
            P_p(i,i) = abs_v^(p-2); %%此处不考虑存储和计算成本,权是相对概念，没有必要都乘以p
            
            if type==1
              S(i,i) = L(i)/dis;
            end
        end
    else
        x00 = x0(1:m)';
        c_off = x0(m+1);
        for i = 1:n
            dif    = X(i,:) - x00;
            dis    = norm(dif);
            A(i,:) = dif./dis;
            dL(i)  =  dis - c_off - L(i);
            
            abs_v = abs(dL(i));
            if abs_v<0.0001
            abs_v = 0.0001;
            end
            P_p(i,i) = abs_v^(p-2); %%此处不考虑存储和计算成本,权是相对概念，没有必要都乘以p
            
            if type==1
            %%ToDO
              S(i,i)=(L(i) + c_off)/dis;
            end
        end
    end
    
    P1 = P0 * P_p; %%此处未考虑计算成本
    
    if flag == 1 %%有钟差参数
        Kn = ones(n,1);
        AA = [A Kn];
        if type==1
            N      = A' * S *P1*A + (trace(P0)-trace(S)) * eye(m); %%当用于抗差估计时效果不理想！！
            %变形1；%%%整体效果好，但当p>2时效果可能差
            %N      = A' *  P1*A + (trace(P0)-trace(S)) * eye(m); 
            %变形2；%%%整体效果好，但当p>2时效果可能差
            %N      = A'*S*P1*A; 
            
            N      = [N  A'*Kn; Kn'*A n];
        else
            N      = (p-1) * AA'*P1*AA; %%0.01
        end
    dx = inv(N)*AA'*P0*(dL'.^(p-1));
    else  %%无钟差参数
        if type==1
          N      = A'*S*P1*A + (trace(P0)-trace(S)) * eye(m);
        else
          N      = A'*P1*A;
        end
    dx = inv(N)*A'*P1*dL';
    end
    
    
    
    x0 = x0 + dx;
    
    k = k + 1;
    xx = [xx x0];
    
    %%停止循环
    if norm(dx)<delt
      break
    end
    if k > 1000
      break
    end
end
%%精度评定
if flag == 1
    VV = dL'-AA*dx;
    sig0_2 = VV'*P1*VV/(n-m-1);
    QQ = inv(AA'*P1*AA)* sig0_2;
else
    VV = dL'-A*dx;
    sig0_2 = VV'*P1*VV/(n-m);
    QQ = inv(A'*P1*A)*sig0_2;
end
    
%%%顾及先验信息
    x0 = inv(N + P) * (N * x0 + P * Pior);
end