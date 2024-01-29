function [S] = rose_more(Side,petal,V1,V2,TNum,TimeNum)



%策略一：载体位置位于四个花瓣的顶点处，同时出发，存在四个载体运动到同一个中心点位的可能

%     S = [0,0,Side,petal,V1,V2,TNum,0,TimeNum,0;
%          0,0,Side,petal,V1,V2,TNum,0,TimeNum,pi/2;
%          0,0,Side,petal,V1,V2,TNum,0,TimeNum,pi;
%          0,0,Side,petal,V1,V2,TNum,0,TimeNum,pi*3/2];
%策略二：四个载体位于同一片花瓣上的不同位置，同时出发
    S = [0,0,Side,petal,V1,V2,TNum,0,TimeNum,0];

%策略三：




%策略四：





end