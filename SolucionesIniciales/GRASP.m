function [PBest,objBest,Feasible]=GRASP(instance,k,nsol)
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
    DistAux=Dist;
    DistDepAux=DistDep;
    DemandAux=D(:,4);
    objBest=inf;
    AuxObjBest=inf;
    PBest=zeros(R,1);
    AllObj=[];
    for j=1:nsol
        Dist=DistAux;
        DistDep=DistDepAux;
        D(:,4)=DemandAux;
        Visited=[];                 %Nodos visitados
        P=zeros(R,1);
        cap=zeros(R,1);
        nxt=zeros(R,1);
        obj=zeros(R,1);
        SatTH=true(R,1);            %Para guardar si se cumple la condicion de distancia
        DistSat=false;
        while sum(D(:,4))>0
            for i=1:R
                node=P(i,end);          %nodo donde esta el vehiculo i
                if SatTH(i) || DistSat
                    if length(Visited)==n
                        nxt(i)=NaN;
                    elseif node==0
                        cap(i)=Q;
                        minKDist=mink(DistDep(setdiff(1:end,Visited)),k);
                        newNode=[];
                        for m=1:length(minKDist)
                            newNode=[newNode
                                    find(DistDep==minKDist(m))'];
                        end
                        newNode=newNode(~ismember(newNode,Visited));
                        if length(newNode)>1
                            newNode=randsample(newNode,1);
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
                            minKDist=mink(Dist(node,:),k);
                            newNode=[];
                            for m=1:length(minKDist)
                                [~,nAux]=find(Dist(node,:)==minKDist(m));
                                newNode=[newNode
                                        nAux'];
                            end
                            newNode=newNode(~ismember(newNode,find(Dist(node,:)==inf)));
                            if length(newNode)>1
                                newNode=randsample(newNode,1);
                            end
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
        AuxObj=0;
        for i=1:R
            if ~Feasible(i)
                AuxObj=AuxObj+obj(i)+1000;
            else
                AuxObj=AuxObj+obj(i);            
            end            
        end
        if AuxObjBest>AuxObj
            PBest=P;
            objBest=obj;
            AuxObjBest=AuxObj;
        end
        AllObj=[AllObj AuxObj];
    end
    Feasible=objBest<TH;
    for i=1:R
        j=1;
        for k=1:size(PBest,2)-1
            if PBest(i,j)==PBest(i,j+1)
                PBest(i,j+1:end)=[PBest(i,j+2:end) NaN];
                j=j-1;
            end
            j=j+1;
        end
    end
    [~,AuxNaN]=find(~isnan(PBest));
    Aux=max(AuxNaN);
    PBest=PBest(:,1:Aux);
    Feasible=~Feasible;
    tEnd=toc(tStart);
    Range="A"+string(R+1)+":B"+string(R+1);
    filename='mtVRP_FHenao_GRASP.xlsx';
    writematrix(nan(R+1,1000),filename,'Sheet',instance,'AutoFitWidth',false)
    writematrix([PBest round(objBest,2) Feasible],filename,'Sheet',instance,'AutoFitWidth',false)
    writematrix([round(sum(objBest),2) round(tEnd,2)],filename,'Sheet',instance,'AutoFitWidth',false,'Range',Range)
end