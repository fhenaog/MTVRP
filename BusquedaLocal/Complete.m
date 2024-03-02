function S=Complete(S,txt)
    S.Z=sum(S.ZRoute);
    S.Th=txt(1,4);
    S.Dist=Distances(txt);
    S.Data=txt;
    S.R=S.Data(1,2);
    S.CapF=1;
end