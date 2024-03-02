function [S]=Objective(SIn,Pop)
    S=SIn;
    Th=Pop.Th;
    Cap=Pop.Q;
    S.CapF=1;     
    for i=1:Pop.R
        CapR=0;
        for j=1:length(S.Sol(i,:))
            if isnan(S.Sol(i,j))
                break
            elseif S.Sol(i,j)==0
                CapR=Cap;
            else
                CapR=CapR-Pop.q(S.Sol(i,j));
            end
            S.CapF=CapR>=0;
            if ~S.CapF
                break
            end
        end
        if ~S.CapF
            break
        end
    end               
    if S.CapF
        S.Z=0;
        S.ZRoute=zeros(Pop.R,1);
        for i=1:Pop.R
            S.ZRoute(i)=CalcDistance(S.Sol(i,:),Pop.Dist);
        end
        S.Z=sum(S.ZRoute);
        S.ThF=S.ZRoute>Th;
        S.ThV=sum(max(S.ZRoute-Th,0));
    else
        S.Z=inf;
        S.ThF=true(S.R,1);
        S.ThV=inf;
    end
    S.ZDist=S.Z;
    S.Z=S.ThV;
    S=rmfield(S,'ThV');
end
    