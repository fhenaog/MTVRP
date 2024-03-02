function Dist = Distances(D)
    n=D(1,1);
    DistDep=zeros(1,n);
    x=D(2,2:3);
    D([1 2],:)=[];
    for i=1:n
        y=D(i,2:3);
        DistDep(i)=norm(x-y);
    end
    Dist=zeros(n,n);
    for i=1:n
        x=D(i,2:3);
        for j=i+1:n
            y=D(j,2:3);
            Dist(i,j)=norm(x-y);
        end
    end
    Dist=Dist+Dist'+diag(inf*ones(1,n));
    Aux=zeros(n+1,n);
    Aux(2:end,:)=Dist;
    Aux(1,:)=DistDep;
    Dist=Aux;
end