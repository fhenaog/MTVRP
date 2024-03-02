function S=toRK(S)
    sl=S.Sol';
    S.Seq=sl(:)';
    S.Seq=S.Seq(~any([S.Seq==0;isnan(S.Seq)]));
    rks=sort(S.RK);
    S.RK=rks(S.Seq);
end