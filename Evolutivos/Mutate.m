function C=Mutate(C,pM,nM,Pop)    
    if rand<pM
        CM=C;
        CM.Z=inf;
        AllRK=zeros(length(Pop.Indv),length(Pop.q));
        for i=1:length(Pop.Indv)
            AllRK(i,:)=Pop.Indv{i}.RK;
        end
        stdRK=std(AllRK);
        n=find(stdRK==min(stdRK));
        for k=1:nM
            C.RK(n)=rand;
            C=Eval(C,Pop);
            if C.Z<CM.Z
                CM=C;
            end
        end
    end
end