function [T,Y,Z,L,theta,Iteration,RayInf] = InAngle(PF,TT,YY,HH,Data,Control,Par)
%% IncidentAngle(PF,TT,YY,HH,tag)->incident angle inversion
Par = Par.InAngle;
%% To swtich the InAng2f
F0 = [TT,YY,HH];
V  = [inf,inf,inf];
if TT == +inf
    idx0 = 3;
    V(idx0) = HH;
    idx = 2; 
end

if YY == +inf 
    idx0 = 1; 
    V(idx0) = TT; 
    idx = 3; 
end

if HH == +inf
    idx0 = 2; 
    V(idx0) = YY; 
    idx = 1; 
end

Var.PF   = PF;
Var.V    = V;
Var.F0   = F0;
Var.idx  = idx;
Var.idx0 = idx0;

%% handle the optimization problem
% if strcmp(RayPar.InitalValue,'Grid')
    
if isfield(Control,'Grid')
%     GridSin_alfa1       = RayPar.DeltaLayer{RayPar.Num}(:,1);
%     GridYY              = RayPar.ExtendLayer(:,2) - RayPar.DeltaLayer{RayPar.Num}(:,2);  
%     Grid                = RayPar.ExtendLayer;
%     
%     InitialScale = InitialValue(YY,Grid);     
%     InitialScale = asin(InitialScale);
elseif isfield(Control,'HeightAngle')
    InitialScale = InitialInAng(Var);
end

if InitialScale(1)==0.05
    [theta,T]=calc_ray_path(YY,Data.RH,Data.SH,Data.PF(:,1),Data.PF(:,2),size(Data.PF,1));
    Y=[];Z=[];L=[];Iteration=[];RayInf=[];
    return 
end
if isfield(Control,'Tangent')  % 割线法
   Var.Initials  = [InitialScale(1),InitialScale(2)];
   Var.TermIter  = Par.TermIter; 
   Var.Terminate = Par.delta; 
   [T,Y,Z,L,theta,Iteration,RayInf] = TangentMethod(@InAng2f111,Var);
%    RayInf = [];
   
 elseif isfield(Control,'WBisection')  % 二分法步长变为加权步长
    Var.Initials  = [InitialScale(1),InitialScale(2)];
    Var.TermIter  = Par.TermIter; 
    Var.delta     = Par.delta; 
    [T,Y,Z,L,theta,Iteration] = WeightBisection(@InAng2f111,Var);  
       
elseif isfield(Control,'Interpolation')  % 根据左右端点限制迭代点的更新  
    TransducerGrid = RayGridExtend(Data.PF,abs(Data.EmissionPoint(3)));
    ExtendLayer = Data.TransponderExtendGrid(:,2:3) - TransducerGrid(:,2:3);   
    Grid = [TransducerGrid(:,1),ExtendLayer(:,1)];
    WindowNum = Par.WindowNum;
    Order     = Par.Order;
    Terminate = Par.delta;  
    [T,Y,Z,L,theta,Iteration,RayInf] = RefinedIncidentAngle(PF,YY,HH,Grid,WindowNum,Order,Terminate);

elseif isfield(Control,'Equation')
    % 拟合格网生成
    TransducerGrid = RayGridExtend(Data.PF,abs(Data.EmissionPoint(3)));
    ExtendLayer = Data.TransponderExtendGrid(:,2:3) - TransducerGrid(:,2:3);
    Grid = [TransducerGrid(:,1),ExtendLayer(:,1)];
      
    % 系数拟合参数设置
    WindowNum = Par.WindowNum;
    Order     = Par.Order;
    Terminate = Par.delta;
    
    % 割线法参数设置
    Var.Initials  = [sin(InitialScale(1)),sin(InitialScale(2))];
    Var.TermIter  = Par.TermIter;
    Var.Terminate = Par.delta;
    Var.Fun       = @Polynomial2f;
    [T,Y,Z,L,theta,Iteration,RayInf] = FirstKind(PF,YY,HH,Grid,WindowNum,Order,Terminate,Var);
end
