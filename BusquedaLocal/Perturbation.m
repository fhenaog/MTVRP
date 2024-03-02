function Sp=Perturbation(S,k)
    %p=1;
    %p=2;
    %p=3;
    %p=randsample(1:3,1,true,[0.3 0.1 0.6]);
    p=randsample(1:3,1);
    if p==1
        %Random exchange
        Sp.CapF=0;
        l=S.R+1:length(S.Sol(:));
        l=l(~isnan(S.Sol(S.R+1:end)));
        while ~Sp.CapF        
            n1=randsample(l,k);
            n2=randsample(l,k);
            Sp=S;
            for i=1:k  
                aux=Sp.Sol(n1(i));
                Sp.Sol(n1(i))=Sp.Sol(n2(i));
                Sp.Sol(n2(i))=aux;
            end
            for j=1:S.R
                lst=find(~isnan(Sp.Sol(j,:)),1,"last");
                if Sp.Sol(j,lst)~=0
                    if lst==size(Sp.Sol,2)
                        aux=nan(S.R,1);
                        aux(j)=0;
                        Sp.Sol=[Sp.Sol aux];
                    else
                        Sp.Sol(j,lst+1)=0;
                    end
                end
            end
            Sp=Objective(Sp);
        end    
        for i=1:S.R
            for j=2:length(Sp.Sol(i,:))
                if Sp.Sol(i,j)==Sp.Sol(i,j-1)
                    Sp.Sol(i,j-1:end)=[Sp.Sol(i,j:end) NaN];
                end
            end
        end
    elseif p==2
        %Random route
        l=1:length(S.Sol(:));
        l=l(all([~isnan(S.Sol(:))'; (S.Sol(:)~=0)']));
        Sp=S;
        n=randsample(l,k);
        car=randperm(S.R,1);
        route=zeros(1,k+2);
        for m=1:k  
            route(m+1)=S.Sol(n(m));
            [i,j]=find(Sp.Sol==S.Sol(n(m)));
            Sp.Sol(i,:)=[Sp.Sol(i,1:j-1) Sp.Sol(i,j+1:end) NaN];
        end
        [Sp.Routes, RCar]=GetRoutes(Sp.Sol);
        Sp.Routes=[Sp.Routes {route}];
        RCar=[RCar car];
        Sol=cell(size(S.Sol,1),1);
        for i=1:length(Sp.Routes)
            r=Sp.Routes{i};
            car=RCar(i);
            Sol{car}=[Sol{car} r(1:end-1)];
        end
        for i=1:Sp.R
            Sol{i}=[Sol{i} 0];
        end       
        Sp.Sol=RebuildSol(Sol);
        Sp=Objective(Sp);
    elseif p==3
        %Random insertion
        Sp.CapF=0;
        f=size(S.Sol,1);
        while ~Sp.CapF
            Sp=S;
            for m=1:k
                l=S.R+1:length(Sp.Sol(:));  
                l=l(~isnan(Sp.Sol(S.R+1:end)));
                n=randsample(l,1);                
                loc=randsample([1:S.R l],1);
                if n~=loc
                    node=Sp.Sol(n);
                    jn=ceil(n/S.R);
                    in=n-(jn-1)*f;
                    Sp.Sol(in,:)=[Sp.Sol(in,1:jn-1) Sp.Sol(in,jn+1:end) NaN];
                    jl=ceil(loc/S.R);
                    il=loc-(jl-1)*f;
                    if in==il && jn<jl
                        jl=jl-1;
                    end
                    Sp.Sol=[Sp.Sol nan(Sp.R,1)];
                    Sp.Sol(il,:)=[Sp.Sol(il,1:jl) node Sp.Sol(il,jl+1:end-1)];
                end
            end
            for i=1:Sp.R
                lnz=find(~isnan(Sp.Sol(i,:)),1,'last');
                if Sp.Sol(i,lnz)~=0
                    Sp.Sol=[Sp.Sol nan(Sp.R,1)];
                    Sp.Sol(i,lnz+1)=0;
                end
            end
            [Sp.Routes, RCar]=GetRoutes(Sp.Sol);
            Sol=cell(size(S.Sol,1),1);
            for i=1:length(Sp.Routes)
                r=Sp.Routes{i};
                car=RCar(i);
                Sol{car}=[Sol{car} r(1:end-1)];
            end
            for i=1:Sp.R
                Sol{i}=[Sol{i} 0];
            end       
            Sp.Sol=RebuildSol(Sol);
            Sp=Objective(Sp);           
        end
    end
end