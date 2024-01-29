function SecondTime = GPSTime2Sec(Data,ReferenceTime)
DataNum = size(Data(:,1),1);
for i = 1:DataNum
    SingleGPSTime   = Data(i,:) - ReferenceTime;
    Day2Sec         = SingleGPSTime(2) * 86400;
    Hour2Sec        = SingleGPSTime(3) * 3600;
    Minute2Sec      = SingleGPSTime(4) * 60;
    Second2Sec      = SingleGPSTime(5);
    SecondTime(i,:) = Day2Sec + Hour2Sec + Minute2Sec + Second2Sec;
end
end

