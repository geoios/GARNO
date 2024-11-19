function [X] = SeafloorCustomizePoints(MP,h)
%% 数据判断
[m,n] =size(MP);
switch n
    case 2
        X(:,1:2) = MP;
        X(:,3)=ErrorFunction(h,0:m-1);
    case 3
        X = MP;
end

