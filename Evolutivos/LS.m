function Best=LS(S,Pop)
    Best=S;
    k=1;
    while k<=2
        if k==1
            SNew=TwoOpt(Best,Pop);
        elseif k==2
            SNew=SwapRoutes(Best,Pop);
        end
        SNew=Objective(SNew,Pop);
        if Acceptance(Best,SNew)
            Best=SNew;
        else
            k=k+1;
        end
    end
    Best=toRK(Best);
    if isfield(Best,'Zi')
        Best=rmfield(Best,'Zi');
    end    
    if isfield(Best,'Routes')
        Best=rmfield(Best,'Routes');
    end
end