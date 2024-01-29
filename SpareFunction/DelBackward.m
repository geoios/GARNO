function [Profi,DelProf] = DelBackward(Profi)

%% 删除声速剖面观测数据内部分异常值
DelProf = [];
while 1
    pf1 = Profi(:,1);
    pf2 = Profi(:,1);
    idxp = [];
    for i = 1:length(pf1)-1
        dpf = pf1(i+1) - pf1(i);
        if dpf == 0             % 下次观测与本次观测深度相同
           Profi(i,2) = (Profi(i,2) + Profi(i+1,2))/2;
           idxp = [idxp i+1];   % 异常值索引
        end
        if dpf < 0              % 下次观测比本次观测深度浅
           idxp = [idxp i+1];   % 异常值索引
        end
    end
    if length(idxp) == 0 ; break;  end
    DelProf = [DelProf;Profi(idxp,:)]; %异常值存贮
    Profi(idxp,:) = [];       % 观测数据中异常值删除
end