function [C] = GenerateMunk_XYZ(X,Y,Z,Cz,MaxH,SSPRefModel,SSPHorModel)
% r表示平均地球半径，存在水圈位于内、外之分。
rModel = 'Interior';
if nargin < 7|| isempty(SSPHorModel)
    SSPHorModel = 'No';
end
    
switch SSPRefModel
    case 'Munk'
        Z_Est = 2*(-Z - Cz)/Cz;
        switch SSPHorModel
            case 'No'
                HorSSPVar = 0;
            case 'Yes'
                if Z<0 % Z>=-320 && Z<=-10
                    gradE = 0 ;gradN = 0;
                    HorSSPVar = gradE * X + gradN * Y;
                else
                    HorSSPVar = 0;
                end
        end
        C = 1500 * (1 + 0.00737 * (Z_Est - 1 + exp(-Z_Est))) + HorSSPVar;
    case 'Munk_3D'
        r = 6371 * 10^3;
        switch rModel
            case 'Out'       % 表示水圈建立在平均半径外；
                R = sqrt(X^2 + Y^2 + (Z - MaxH + r)^2) - r + MaxH ;
                Z_Est = 2 * (-R - Cz)/Cz;
            case 'Interior'  % 表示水圈建立在平均半径内
                R = sqrt(X^2 + Y^2 + (Z + r)^2) - r;
                Z_Est = 2 * (-R - Cz)/Cz;
        end
        C = 1500 * (1 + 0.00737 * (Z_Est - 1 + exp(-Z_Est)));
end

end

