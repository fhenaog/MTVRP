function Best=SplitRouteVND(S)
    Best=S;
    Best.ThF=true(Best.R,1);
    Best.Z=inf;
    S=ObjectiveVND(S);
    if ~S.CapF
        return
    end
    indMax=find(S.ZRoute==max(S.ZRoute));
    indMax=indMax(1);
    indMin=find(S.ZRoute==min(S.ZRoute));
    indMin=indMin(1);
    Route=S.Sol(indMax,:);
    Rs=GetRoutes(Route);
    Route=Rs{end}';
    Routes={};
    for i=1:S.R
        if i==indMax
            l=length(Route)-1;
            ind=find(~isnan(S.Sol(i,:)),1,'last');
            Routes{i}=S.Sol(i,1:ind-l);
        else
            Routes{i}=S.Sol(i,~isnan(S.Sol(i,:)));
        end
    end
    RoutesAux=Routes';
    SNew=S;
    for i=2:length(Route)-2 
        Routes=RoutesAux;
        R1=[Route(2:i) 0];
        R2=Route(i+1:end);
        Routes{indMax}=[Routes{indMax} R1];
        Routes{indMin}=[Routes{indMin} R2]; 
        SNew.Sol=RebuildSol(Routes);
        SNew=ObjectiveVND(SNew);
        if SNew.CapF && SNew.Z<Best.Z%sum(SNew.ThF)<sum(Best.ThF)
            Best=SNew;
        end
    end
end