function [TIME,detalSec,detalDay] = TimeCreate( LaunchRT,TStart,TEnd,T,SpanTime,HardwareDelay)
%Year 生成时间所在年份;TStart 起始时间;TEnd终止时间;T 时间间隔

number = (TEnd - TStart)/T;

if nargin<5||isempty(SpanTime)
    SpanTime=zeros(fix(number),1);
end
if nargin<6||isempty(HardwareDelay)
    HardwareDelay=0;
end
Year = LaunchRT(1); DOY = day(datetime(LaunchRT(1:3)),'dayofyear');
Hour = LaunchRT(4); Min = LaunchRT(5); Sec = LaunchRT(6);
detalSec = TStart + (0:number-1) * T + HardwareDelay + SpanTime';
detalDay = detalSec/24/3600;
DATA=datetime(Year,1,DOY,Hour,Min,Sec + detalSec);

DataTime=datevec(DATA);
TIME=DataTime(:,2:end);

end

