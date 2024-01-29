function [S] = ErrorFunction(coefficient,X)
[m,n]=size(coefficient);
if size(X,2)>2
    X=X';
end
for j=1:m
    Num=[0,0,0,0,1,0,0,1,0,0,1,0,0,1,0];
    for i=1:n
        Num(i)=coefficient(m,i);
    end
    if Num([4,7,10,13])==0
        if  Num([5,8,11,14])==0
            Num([5,8,11,14])=1;
        end
    end
    S(:,j)=Num(1)*randn(length(X),1)+Num(2)+Num(3)*X+Num(4)*sin(2*pi/Num(5)*X+Num(6))+...
        Num(7)*cos(2*pi/Num(8)*X+Num(9))+Num(10)*sin(2*pi/Num(11)*X+Num(12))+Num(13)*sin(2*pi/Num(14)*X+Num(15));
end
end

