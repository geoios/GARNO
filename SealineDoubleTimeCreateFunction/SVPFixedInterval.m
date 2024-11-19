function [SubProfile] = SVPFixedInterval(SubProfile,MaxH,LayerLag)

SVP=SubProfile;
SubProfile=[];

% 样条插值自定义间隔声速
H=SVP(:,1);V=SVP(:,2);
Hight = unique([LayerLag,MaxH]);
Speed = interp1(H,V,Hight,'spline');
Hight = [0,Hight];Speed = [V(1),Speed];


index1 = find(H <= 2600,1,'last');
index2 = find(Hight<= 2600,1,'last');
Findex = index1 - 10;
NewfitX = H(Findex:index1);
NewfitY = V(Findex:index1);
[p] = LSNH(NewfitX,NewfitY',1);
NewfitHight = Hight(index2:end);

for j = 1:length(NewfitHight)
    NewfitSpeed(j) = p(1)*NewfitHight(j)+p(2);
end

Speed(index2:end) = NewfitSpeed;
SubProfile(:,1) = Hight; SubProfile(:,2) = Speed;
end

