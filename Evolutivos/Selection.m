function [P1, P2]=Selection(Indv)
    n=length(Indv);
    ncand1=randi(n);
    ncand2=randi(n);
    while ncand1==ncand2
        ncand2=randi(n);
    end
    cand1=Indv{ncand1};
    cand2=Indv{ncand2};
    if Acceptance(cand1,cand2)
        P1=cand2;
        nP1=ncand2;
    else
        P1=cand1;
        nP1=ncand1;
    end
    nP2=nP1;
    while nP2==nP1
        ncand1=randi(n);
        ncand2=randi(n);
        while ncand1==ncand2
            ncand2=randi(n);
        end
        cand1=Indv{ncand1};
        cand2=Indv{ncand2};
        if Acceptance(cand1,cand2)
            P2=cand2;
            nP2=ncand2;
        else
            P2=cand1;
            nP2=ncand1;
        end
    end
end