function [ x0,dL,xx,k ] = Netwon(  X,L,x0,P0,delt )
[n m]=size(X);
k=0;
xx=[];
while (1)
    for i = 1 : n
        dif    = X(i,:) - x0';
        dis    = norm(dif);
        A(i,:) = dif./dis;
        dL(i)  = dis - L(i);
        
    end
    P1 = P0 ; %%此处未考虑计算成本
    N      = A'*P1*A ;
    dx = inv(N)*A'*P1*dL';

    x0 = x0 + dx;
    
    xx = [xx x0];
    k = k + 1;
    
    %%停止循环
    if norm(dx)<delt
      break
    end
    if k > 1000
      break
    end
end

end

