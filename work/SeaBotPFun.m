function [F] = SeaBotPFun(Side,H,SeaBotModel)

switch SeaBotModel
    case 'Square+Centre'
        F = [0,0,-H;
            Side,Side,-H;
            -Side,-Side,-H;
            Side,-Side,-H;
            -Side,Side,-H];
    case 'Square'
        F = [Side,Side,-H;
            -Side,-Side,-H;
            Side,-Side,-H;
            -Side,Side,-H];
    case 'Centre'
        F = [0,0,-H];
    case 'M02'
        F = [1060.6602,1060.6602,-H];
    case 'M03'
        F = [-1060.6602,-1060.6602,-H];   
    case 'M04'
        F = [1060.6602,-1060.6602,-H];
    case 'M05'
        F = [-1060.6602,1060.6602,-H];    
    case 'Scatter'
        F = [(0:1000:6000)', zeros(7,1),-H * ones(7,1)];
        
end



end

