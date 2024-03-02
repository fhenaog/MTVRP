function Sol=RebuildSol(RoutesCar)
    maxR=0;    
    for i=1:length(RoutesCar)
        maxR=max(maxR,length(RoutesCar{i}));
    end
    for i=1:length(RoutesCar)
        l=length(RoutesCar{i});
        RoutesCar{i}=[RoutesCar{i} nan(1,maxR-l)];
    end
    Sol=cell2mat(RoutesCar);
end