function Seq=TranslateRK(RK)
    [~,I]=sort(RK);
    Seq(I)=1:length(RK);
end