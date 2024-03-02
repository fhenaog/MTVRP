function Best = TwoOpt(S,Pop)    
    [S.Routes, RCar]=GetRoutes(S.Sol);
    Best=S;
    Best.Zi=inf;
    Best.Z=0;
    for nR=1:length(S.Routes)
        S.Route=S.Routes{nR};
        S.Zi=CalcDistance(S.Route,Pop.Dist);
        Best.Zi=S.Zi;
        n=length(S.Route);
        for i=2:n-2
            for j=i+1:n-1
                SNew=S;
                seq=S.Route(i:j);
                SNew.Route(i:j)=flip(seq);
                SNew.Zi=CalcDistance(SNew.Route,Pop.Dist);
                if SNew.Zi<Best.Zi
                    Best.Routes{nR}=SNew.Route;
                    Best.Zi=SNew.Zi;
                end
            end
        end        
        Best.Z=Best.Z+Best.Zi;
    end
    %Rebuild Route
    Sol=cell(size(S.Sol,1),1);
    for i=1:length(Best.Routes)
        r=Best.Routes{i};
        car=RCar(i);
        Sol{car}=[Sol{car} r(1:end-1)];
    end
    for i=1:Pop.R
        Sol{i}=[Sol{i} 0];
    end       
    Best.Sol=RebuildSol(Sol);
    Best.ZRoute=zeros(Pop.R,1);
    Best.ThV=0;
    for i=1:Pop.R
        Best.ZRoute(i)=CalcDistance(Best.Sol(i,:),Pop.Dist);
        Best.ThV=Best.ThV+max(Best.ZRoute(i)-Pop.Th,0);
    end
    Best.ZDist=Best.Z;
    Best.Z=Best.ThV;
end