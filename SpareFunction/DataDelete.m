function Data = DataDelete(Data,idx)
if isfield(Data,'Elevations')
    Data.Elevations(idx,:) = [];
end
Data.LControl(idx,:) = [];
Data.rControl(idx,:) = [];
Data.DelayTime(idx,:) =  [];
Data.rTime(idx,:) =  [];
Data.LTime(idx,:) =  [];
Data.rRs(:,:,idx) = [];
Data.LRs(:,:,idx) = [];
Data.EpochNum = length(Data.DelayTime);