function Best=SwapRoutes(S,Pop)
    Best=S;
    Best.ThF=true(Pop.R,1);
    Best.Z=inf;
    [Routes, RCar]=GetRoutes(S.Sol);
    Aux=RCar;
    for k=1:length(RCar)
        r1=RCar(k);
        for j=k+1:length(RCar)
            r2=RCar(j);            
            if r1~=r2
                RCar(k)=r2;
                RCar(j)=r1;
                SNew=S;
                Sol=cell(size(S.Sol,1),1);
                for i=1:length(Routes)
                    r=Routes{i};
                    car=RCar(i);
                    Sol{car}=[Sol{car} r(1:end-1)];
                end
                for i=1:Pop.R
                    Sol{i}=[Sol{i} 0];
                end       
                SNew.Sol=RebuildSol(Sol); 
                SNew=Objective(SNew,Pop);
                if Acceptance(Best,SNew)
                    Best=SNew;
                end
                RCar=Aux;
            end
        end        
    end
end