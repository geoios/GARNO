function [ pole_de,pole_dn,pole_du ] = Transform( Heading,Pitch,Roll,Forward,Rightward,Downward )
%TRANSFORM 此处显示有关此函数的摘要
%   此处显示详细说明
% 
yw=Heading*pi/180;
rl=Roll*pi/180;
pc=Pitch*pi/180;

crl=cos(rl);srl=sin(rl);
cpc=cos(pc);spc=sin(pc);
cyw=cos(yw);syw=sin(yw);

tr_rl=[1,0,0;0,crl,-srl;0,srl,crl];
tr_pc=[cpc,0,spc;0,1,0;-spc,0,cpc];
tr_yw=[cyw,-syw,0;syw,cyw,0;0,0,1];

trans=tr_yw*tr_pc*tr_rl;
atd=[Forward,Rightward,Downward];
dned=trans*atd';

pole_de=dned(2);
pole_dn=dned(1);
pole_du=-dned(3);

end

