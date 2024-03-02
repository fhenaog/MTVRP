function Best=SwapRoutesVND(S)
    Best=S;
    Best.ThF=true(Best.R,1);
    Best.Z=inf;
    [Routes, RCar]=GetRoutes(S.Sol);
    Aux=RCar;
    for k=1:length(RCar)
        r1=RCar(k);
        for j=k+1:length(RCar)
            r2=RCar(j);            
            if r1~=r2 && r2~=RCar(j-1)
                RCar(k)=r2;
                RCar(j)=r1;
                SNew=S;
                Sol=cell(size(S.Sol,1),1);
                for i=1:length(Routes)
                    r=Routes{i};
                    car=RCar(i);
                    Sol{car}=[Sol{car} r(1:end-1)];
                end
                for i=1:SNew.R
                    Sol{i}=[Sol{i} 0];
                end       
                SNew.Sol=RebuildSol(Sol); 
                SNew=ObjectiveVND(SNew);
                if SNew.Z<Best.Z
                    Best=SNew;
                end
                RCar=Aux;
            end
        end        
    end
end