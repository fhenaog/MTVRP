function Pop=Complete(Pop,txt)
    Pop.Th=txt(1,4);
    Pop.Dist=Distances(txt);
    Pop.Data=txt;
    Pop.R=Pop.Data(1,2);
    Pop.q=Pop.Data(3:end,4);
    Pop.Q=Pop.Data(1,3);
end