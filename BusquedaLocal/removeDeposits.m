function S=removeDeposits(S)
    [f, c]=find(S.Sol==0);
    for i=length(f):-1:1
        row=f(i);
        col=c(i);
        if col~=1 && col~=size(S.Sol,2) && ~isnan(S.Sol(row,col+1))
            New=S;
            New.Sol(row,:)=[S.Sol(row,1:col-1) S.Sol(row,col+1:end) NaN];
            New=Objective(New);
            if New.CapF
                S=New;
            end
        end
    end
    [~,AuxNaN]=find(~isnan(S.Sol));
    Aux=max(AuxNaN);
    S.Sol=S.Sol(:,1:Aux);
    S=Objective(S);
end