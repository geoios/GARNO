function PF_New = ProfileResample(PF,MaxH,step)
win = 3;
PF_New(1,1) = 0;
PF_New(1,2) = PF(1,2);
PF = PFGrad(PF,win,1);
for i=1:MaxH*1/step
    hi = i * step;
    idx = find(PF(:,1)>=hi,1);
    try
        ci = PF(idx-1,2) + PF(idx-1,4) * (hi-PF(idx-1,1));
    catch
        i=1;
    end
    PF_New(i+1,1) = hi;
    PF_New(i+1,2) = ci;
end