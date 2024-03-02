function Best=LSSwap(S,Pop)
    Best=S;
    while true
        SNew=SwapRoutes(Best,Pop);
        if Acceptance(Best,SNew)
            Best=SNew;
        else
            break
        end
    end
end