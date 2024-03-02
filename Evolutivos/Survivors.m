function Pop=Survivors(Pop,pi)
    Indv=[Pop.Indv{:}];
    ObInd=[Indv.Z];
    [SObj,Surv]=sort(ObInd);
    [~,uq,~] = unique(SObj);
    Surv=Surv(uq);
    if sum(ObInd==0)>pi
        Surv=Surv(sort(ObInd)==0);
        Indv=[Pop.Indv{Surv}];
        ObInd=[Indv.ZDist];
        [~,SurvZ]=sort(ObInd);
        Surv=Surv(SurvZ);
    end
    Surv=Surv(1:pi);
    Pop.Indv=Pop.Indv(Surv);
end