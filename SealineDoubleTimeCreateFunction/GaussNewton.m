function [x0 k QQ sig0_2 dL] = GaussNewton(X,L,x0,delt,flag)
%%
% X 控制点坐标
% L 距离观测
% x0 初值
% delt 迭代误差
% flag： 0 无钟差 1含钟差
%
[n m]=size(X);

k=0;
while (1)
    if flag == 0
        for i = 1:n
            dif = X(i,:) - x0;
            dis = norm(dif);
            A(i,:) = dif./dis;
            dL(i) =dis - L(i) ;
        end
    else
        x00 = x0(1:m)';
        for i = 1:n
            dif = X(i,:) - x00;
            dis = norm(dif);
            A(i,:) = dif./dis;
            dL(i) = L(i) - dis + x0(m+1);
        end
    end
    
    if flag == 1
          AA = [A ones(n,1)];
          dx = inv(AA'*AA)*AA'*dL';
    else
          dx = inv(A'*A)*A'*dL';
    end
    
    x0 = x0 - dx;%%%！！！档存在钟差 和  不存在时 ，程序存在不一致，会导致错误!!
    k = k + 1;
   
    
    %%停止循环
    if norm(dx)<delt
      break
    end
    if k > 100
      break
    end
end

    if flag == 1
    VV = dL'-AA*dx;
    sig0_2 = VV'*VV/(n-m-1);
    QQ = inv(AA'*AA)* sig0_2;
    else
    VV = dL'-A*dx;
    sig0_2 = VV'*VV/(n-m);
    QQ = inv(A'*A)*sig0_2;
    end
end