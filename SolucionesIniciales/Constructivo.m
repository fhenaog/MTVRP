function [P,obj,Feasible,CotaInf]=Constructivo(instance)
    tStart=tic;
    filename=mfilename('fullpath');
    [path,~,~] = fileparts(filename);
    D=importdata(path+"\mtVRP Instances\"+instance+".txt");
    n=D(1,1);
    R=D(1,2);
    Q=D(1,3);
    TH=D(1,4);
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
    Dist=Dist+Dist'+diag(inf*ones(1,n));  %Hacer la matriz simetrica
                                            % y la diagonal infinito
    Visited=[];                 %Nodos visitados
    P=zeros(R,1);
    cap=zeros(R,1);
    nxt=zeros(R,1);
    obj=zeros(R,1);
    SatTH=true(R,1);            %Para guardar si se cumple la condicion de distancia
    DistSat=false;
    %Calcular la cota inferior
    minDep=mink(DistDep,2*R);
    CotaInf=sum(minDep);
    used=true(1,n);
    aux=1:n;
    for i=R+1:2*R
        ind=find(DistDep==minDep(i));
        ind=ind(~ismember(ind,aux(~used)));
        if length(ind)>1
            ind=ind(1);
        end
        used(ind)=false;
    end
    CotaInf=CotaInf+sum(min(Dist(used,used),[],2));
    for i=1:n
        %if ~ismember(i,aux(~used))
            
            used(i)=false;
        %end
    end
    while sum(D(:,4))>0
        for i=1:R
            node=P(i,end);          %nodo donde esta el vehiculo i
            if SatTH(i) || DistSat
                if length(Visited)==n
                    nxt(i)=NaN;
                elseif node==0
                    cap(i)=Q;
                    newNode=find(DistDep==min(DistDep(setdiff(1:end,Visited))));
                    newNode=newNode(~ismember(newNode,Visited));
                    if length(newNode)>1    
                        newNode=newNode(1); 
                    end 
                    if any(Visited==newNode)
                        D(newNode,4)
                        nxt(i)=0;
                    elseif obj(i)+DistDep(newNode)<=TH || DistSat
                        nxt(i)=newNode;
                        obj(i)=obj(i)+DistDep(newNode);
                        cap(i)=cap(i)-D(newNode,4);
                        D(newNode,4)=0;
                        Dist(:,newNode)=inf;  
                        Visited=[Visited newNode];
                    else
                        SatTH(i)=false;
                    end
                else
                    if cap(i)==0
                        nxt(i)=0;
                        obj(i)=obj(i)+DistDep(node);
                    else
                        [~,newNode]=find(Dist(node,:)==min(Dist(node,:)));
                        if length(newNode)>1    
                            newNode=newNode(1); 
                        end            %por si hay varios nodos con min distancia     
                        if any(Visited==newNode)
                            nxt(i)=0;
                            obj(i)=obj(i)+DistDep(node);
                        elseif obj(i)+Dist(node,newNode)+DistDep(newNode)<=TH || DistSat
                            if cap(i)>=D(newNode,4)
                                nxt(i)=newNode;
                                obj(i)=obj(i)+Dist(node,newNode);
                                cap(i)=cap(i)-D(newNode,4);                                
                                D(newNode,4)=0;
                                Dist(:,newNode)=inf;  
                                Visited=[Visited newNode];
                            else
                                nxt(i)=0;
                                obj(i)=obj(i)+DistDep(node);
                            end                            
                        else
                            SatTH(i)=false;
                        end
                    end                                
                end
            end
        end
        if ~any(SatTH)
            DistSat=true;
        end
        P=[P nxt];
    end
    for i=1:R
        nonNaN=find(~isnan(P(i,:)));
        last=nonNaN(end);
        if P(i,last)==0
            nxt(i)=NaN;
        else
            if last==size(P,2)
                nxt(i)=0;
            else
                P(i,last+1)=0;
                nxt(i)=NaN;
            end
            obj(i)=obj(i)+DistDep(P(i,last));
        end
    end
    Feasible=obj<TH;
    P=[P nxt];
    for i=1:R
        j=1;
        for k=1:size(P,2)-1
            if P(i,j)==P(i,j+1)
                P(i,j+1:end)=[P(i,j+2:end) NaN];
                j=j-1;
            end
            j=j+1;
        end
    end
    [~,AuxNaN]=find(~isnan(P));
    Aux=max(AuxNaN);
    P=P(:,1:Aux);
    Feasible=~Feasible;
    tEnd=toc(tStart);
    Range="A"+string(R+1)+":B"+string(R+1);
    filename='mtVRP_FHenao_Constructivo.xlsx';
    writematrix(nan(R+1,1000),filename,'Sheet',instance,'AutoFitWidth',false)
    writematrix([P round(obj,2) Feasible],filename,'Sheet',instance,'AutoFitWidth',false)
    writematrix([round(sum(obj),2) round(tEnd,2)],filename,'Sheet',instance,'AutoFitWidth',false,'Range',Range)
end