function [ X ] = Roses( X0,A,K,w,a,T,TStart,TEnd )
% X0为中心坐标
% A为包络半径
% K为控制叶子的个数、叶子的大小及周期参数
% w 为角速度
% a 为角加速度
% T 为观测间隔时间
% TStart为起始时间
% TEnd为终止时间

b=0;
c=0;

for k=1:1:TEnd/T+1
    t=(k-1)*T;
    %% 加速度与时间的关系式
    AA(k)=a+b*t+c*t^2;
    %----------------------%
end

Angle(1)=0;
j=0;
for i=1:1:TEnd/T
    angle=w*T+1/2*(AA(i+1)+AA(i))/2*T^2;
    w=w+(AA(i+1)+AA(i))/2*T;
    Angle(i+1)=Angle(i)+angle;
    if i>fix(TStart/T)
        j=j+1;
        theta(j)=Angle(i+1);
    end
end
if K==fix(K)
   if K/2 == fix(K/2)
    % 当k为整数且为偶数时，玫瑰线叶子的个数为2*k，周期为2*pi。
    rho=A*cos(K*theta);
   else
    %%%当k为整数且为奇数时，玫瑰线叶子的个数为k，周期为pi。
    rho=A*cos(K*theta);
   end
else
    z=rats(K);
    [~,~,~, matches]=regexp(z,'\d+');
    for i=1:length(matches)
        Z(i)=str2num(cell2mat(matches(i)));
    end
    k1=Z(1);
    k2=Z(2);
    if k1/2 ~= fix(k1/2)
        if k2/2 ~= fix(k2/2)
            rho=A*cos(K*theta);
        else
            rho=A*cos(K*theta);
        end
    else
        %% TODO
            rho=A*cos(K*theta);
    end
end
%[theta, r]=cart2pol(x,y) %将笛卡尔坐标转换为极坐标

[x,y]=pol2cart(theta, rho); %将极坐标转换为笛卡尔坐标

x=x+X0(1,1);
y=y+X0(1,2);
X = [x' y'];
end

%玫瑰线方程的表达如下图：
%rho=a*sin(k*theta)
%rho=a*cos(k*theta)。
%当k为整数且为奇数时，玫瑰线叶子的个数为k，周期为pi；
%当k为整数且为偶数时，玫瑰线叶子的个数为2*k，周期为2*pi；
%当k为分数（N/D），分子N分母D均为奇数时，玫瑰线叶子数为N，周期为D*pi，分子N分母D有一个为偶数时，玫瑰线叶子数为2*N，周期为2*D*pi。
