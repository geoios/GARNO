function [GDOP1 A] = GDOP1(Unknown,Knowns)
%%%第一类GDOP
%传入参数 Unknown=x,Kowns=X'
[m,n]=size(Knowns); %读取X'的行和列的元素个数
A=[];
for i=1:n
    Dif=Unknown-Knowns(:,i)';
    Dis=norm(Dif);
    A=[A;Dif/Dis];
end
InvN=inv(A'*A);
GDOP1=trace(InvN);
GDOP1=sqrt(GDOP1);