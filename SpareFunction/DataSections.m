function Data = DataSections(Data,Par)
BreakTimeInterval = Par.DataSections.BreakTimeInterval;
BP = BreakPointDetect(Data.rTime,BreakTimeInterval);
for k = 1:length(BP)-1
    iSec = [BP(k):BP(k+1)-1];
    if k == length(BP) - 1
        iSec = [BP(k):BP(k+1)];
    end
    SectionIdx{k} = iSec;
    %TimePoints([2*k-1 2*k],:) = Data.RTime([iSec(1) iSec(end)]);
end
Section.Idx = SectionIdx;
Section.BP = BP;
%Section.TimePoints = TimePoints;
Section.TimePoints = Data.rTime(BP);
Data.Section = Section;