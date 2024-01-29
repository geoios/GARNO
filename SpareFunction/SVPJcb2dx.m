function [dX] = SVPJcb2dx(M,mp,MTindex,detalp,svp)
%% 构建B样条区间
KnotTT=[M.ST(1),M.RT(end)];
%% 解算
for MPNum=1:length(mp)
    tmp=mp;
    tmp(MPNum)=tmp(MPNum)+detalp;
       for q=1:size(M,1)
        index=M.MTPSign(q);
        [NewSVPStr]=GreationSVP(M.ST(q),svp,tmp(size(MTindex,2)*3+1:end),KnotTT,3);
        [NewSVPEnd]=GreationSVP(M.RT(q),svp,tmp(size(MTindex,2)*3+1:end),KnotTT,3);
        SVPDataStr.PF= PFGrad(NewSVPStr,2,1);
        SVPDataEnd.PF= PFGrad(NewSVPEnd,2,1);
        ModelTT1=P2PInvRayTrace([M.transducer_e0(q),M.transducer_n0(q),M.transducer_u0(q)],tmp((index-1)*3+1:index*3),SVPDataStr);
        ModelTT2=P2PInvRayTrace([M.transducer_e1(q),M.transducer_n1(q),M.transducer_u1(q)],tmp((index-1)*3+1:index*3),SVPDataEnd);
        ModelT(q)=ModelTT1+ModelTT2;
       end
    jcb(:,MPNum)=(ModelT'-M.ModelT)/detalp;
end
dX=inv(jcb'*jcb)*jcb'*M.detalT;
end

