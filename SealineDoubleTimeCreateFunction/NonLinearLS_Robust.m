function [x0 dL Aalf sig] = NonLinearLS_Robust(A,L,x0,delat)
k=0;[m,n]=size(A);
while(1)
    L0 = zeros(1,m);
    B = zeros(m,3);
    k=k+1;
    x1=x0;
    for j = 1:m
        Diffj = x0-A(j,:);
        DiffjL = sqrt(Diffj(1)^2+Diffj(2)^2+Diffj(3)^2);%norm(Diffj);
        L0(j)=DiffjL;
        B(j,:)=Diffj/DiffjL;
    end
    dL=(L-L0')';
    Qx = B'*B;
    %Qx(3,3) = Qx(3,3) + 100; %%ÕýÔò»¯
    dx = inv(Qx)*B'*dL';

%     dx=B\dL;
    x0 = x0 + dx';

    Aalf = B(:,3);
    sig = sqrt(dL * dL'/(m-3));
    
%     for jj = 1:length(dL)
%         if abs(dL(jj)) > 1000000000.5 * sig
%             m = m -1;
%             A(jj,:) = [];
%             L(jj,:) = [];
%         end
%     end
    
    if k>20
     break
    end
     if norm(dx)<delat
       break
     end
end