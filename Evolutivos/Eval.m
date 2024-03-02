function S=Eval(S,Pop)
    S.Seq=TranslateRK(S.RK);
    seq=SplitR(length(S.Seq),Pop.Q,S.Seq,Pop.Dist,Pop.q,Pop.Th);
    S.Sol=RebuildSeq(seq,Pop.R,Pop.Dist);
    S=Objective(S,Pop);
end