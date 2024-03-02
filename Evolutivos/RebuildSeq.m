function Sol=RebuildSeq(Seq,R,Dist)
    Routes=GetRoutes(Seq);
    Zcar=zeros(R,1);
    RCar=ones(length(Routes),1);
    for i=1:length(Routes)
        Zrt=CalcDistance(Routes{i},Dist);
        [~,c]=min(Zcar);
        RCar(i)=c;
        Zcar(c)=Zcar(c)+Zrt;
    end
    RoutesCar=cell(R,1);
    for i=1:length(Routes)
        r=Routes{i};
        car=RCar(i);
        RoutesCar{car}=[RoutesCar{car} r(1:end-1)'];
    end
    for i=1:R
        RoutesCar{i}=[RoutesCar{i} 0];
    end 
    Sol=RebuildSol(RoutesCar);
end