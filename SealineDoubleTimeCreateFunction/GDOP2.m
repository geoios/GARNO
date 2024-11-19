function [GDOP2 A] = GDOP2(Unknown,Knowns)
%%%µ⁄“ª¿‡GDOP
[m,n]=size(Knowns);
A=[];
for i=1:n
    Dif=Unknown-Knowns(:,i)';
    Dis=norm(Dif);
    A=[A;[Dif/Dis 1]];
end
InvN=inv(A'*A);
GDOP2=trace(InvN);
GDOP2=sqrt(GDOP2);
A = A(:,1:3);