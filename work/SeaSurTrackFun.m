function [S] = SeaSurTrackFun(Side,TimeNum,TNum,FA,T,V,SurShape)

switch SurShape
    case 'Scatter'
            S = [Side,Side,V,0,TNum,0,1*TimeNum,180
            Side,-Side,V,0,TNum,1*TimeNum,2*TimeNum,270
            -Side,-Side,V,0,TNum,2*TimeNum,3*TimeNum,0
            -Side,Side,V,0,TNum,3*TimeNum,4*TimeNum,90];
    
    case 'Square'
        S = [Side,Side,V,0,TNum,0,1*TimeNum,180
            Side,-Side,V,0,TNum,1*TimeNum,2*TimeNum,270
            -Side,-Side,V,0,TNum,2*TimeNum,3*TimeNum,0
            -Side,Side,V,0,TNum,3*TimeNum,4*TimeNum,90];
        
    case 'CrossLine_8' % 正方形 + 米字形
        
        XSide1=Side*sin((180+45+FA)*pi/180);YSide1=Side*cos((180+45+FA)*pi/180);
        XSide2=Side*sin((90+45+FA)*pi/180);YSide2=Side*cos((90+45+FA)*pi/180);
        XSide3=Side*sin((45+FA)*pi/180);YSide3=Side*cos((45+FA)*pi/180);
        XSide4=Side*sin((-45+FA)*pi/180);YSide4=Side*cos((-45+FA)*pi/180);
        XSide5=Side*sin((225+FA)*pi/180);YSide5=Side*cos((225+FA)*pi/180);
        XSide6=Side*sin((90+FA)*pi/180);YSide6=Side*cos((90+FA)*pi/180);
        XSide7=Side*sin((-45+FA)*pi/180);YSide7=Side*cos((-45+FA)*pi/180);
        XSide8=Side*sin((180+FA)*pi/180);YSide8=Side*cos((180+FA)*pi/180);
        
        V1 = V(1);V2 = V(2);
        
        S = [ XSide1,YSide1,V1,0,TNum,T,TimeNum+T,90+FA;
            XSide2,YSide2,V1,0,TNum,TimeNum+T,2*TimeNum+T,0+FA;
            XSide3,YSide3,V1,0,TNum,2*TimeNum+T,3*TimeNum+T,270+FA;
            XSide4,YSide4,V1,0,TNum,3*TimeNum+T,4*TimeNum+T,180+FA;
            XSide5,YSide5,V2,0,TNum,4*TimeNum+T,5*TimeNum+T,45+FA;
            XSide6,YSide6,V2,0,TNum,5*TimeNum+T,6*TimeNum+T,270+FA;
            XSide7,YSide7,V2,0,TNum,6*TimeNum+T,7*TimeNum+T,135+FA;
            XSide8,YSide8,V2,0,TNum,7*TimeNum+T,8*TimeNum+T,FA];
    case 'Yokota(2015)'
        
        
        
        
        
end
end

