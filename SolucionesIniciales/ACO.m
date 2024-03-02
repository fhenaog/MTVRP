function [PBest,objBest,Feasible]=ACO(instance,m,Q,alpha,beta,rho,nColonies,nxlxs)
    tStart=tic;
    filename=mfilename('fullpath');
    [path,~,~] = fileparts(filename);
    D=importdata(path+"\mtVRP Instances\"+instance+".txt");
    n=D(1,1);
    R=D(1,2);
    maxCap=D(1,3);
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
            if Dist(i,j)==0
                Dist(i,j)=0.001;
            end
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
    pheromones=ones(n+1,n+1);    
    eta=[1./Dist 1./DistDep'
        1./DistDep 0];
    for colony=1:nColonies
        %repetir por colonia
        %matriz de probabilidades
        DPheromones=zeros(n+1,n+1);
        auxNum=(pheromones).^(alpha).*(eta).^(beta);
        auxDen=sum(auxNum,2);
        Pij=auxNum./auxDen;
        for k=1:m
            %repetir por hormiga
            Dist=DistAux;
            DistDep=DistDepAux;
            D(:,4)=DemandAux;
            Visited=[];                 %Nodos visitados            
            Path=0;
            Routes={};
            cap=0;
            nxt=0;
            obj=0;   
            while sum(D(:,4))>0
                node=Path(end);
                if length(Visited)==n
                    nxt=NaN;
                elseif node==0
                    cap=maxCap; 
                    Possible=setdiff(1:n,Visited);
                    Prob=Pij(end,Possible);
                    if length(Possible)==1
                        newNode=Possible;
                    else
                        newNode=randsample(Possible,1,true,Prob);
                    end
                    nxt=newNode;
                    obj=obj+DistDep(newNode);
                    cap=cap-D(newNode,4);
                    D(newNode,4)=0;
                    Dist(:,newNode)=inf;  
                    Visited=[Visited newNode];
                else 
                    if cap==0
                        nxt=0;
                        obj=obj+DistDep(node);
                        Path=[Path nxt];
                        Routes=[Routes
                            {Path obj}];
                        obj=0;
                        Path=[];
                    else
                        Possible=setdiff(1:n+1,Visited);
                        Prob=Pij(node,Possible);
                        if all(Prob==0)
                            aux=size(Prob,2);
                            Prob=(1/aux)*ones(1,aux);
                        end
                        if length(Possible)==1
                            newNode=Possible;
                        else
                            newNode=randsample(Possible,1,true,Prob);
                        end
                        if newNode ~= n+1 && cap>=D(newNode,4)
                            nxt=newNode;
                            obj=obj+Dist(node,newNode);
                            cap=cap-D(newNode,4);                                
                            D(newNode,4)=0;
                            Dist(:,newNode)=inf;  
                            Visited=[Visited newNode];
                        else
                            nxt=0;
                            obj=obj+DistDep(node);
                            Path=[Path nxt];
                            Routes=[Routes
                            {Path obj}];
                            obj=0;
                            Path=[];
                        end      
                    end
                end
                Path=[Path nxt];
            end
            Path=[Path 0];
            obj=obj+DistDep(nxt);
            Routes=[Routes
                {Path obj}];
            maxLen=0;
            nR=length(Routes);
            for i=1:nR
                maxLen=max(maxLen,length(Routes{i,1}));
            end
            for i=1:nR
                Routes{i,1}=[Routes{i,1} zeros(1,maxLen-length(Routes{i,1}))];
            end
            Routes=sortrows(Routes,2,'ascend');
            P=zeros(R,nR*maxLen);
            obj=zeros(R,1);
            for i=1:R
                P(i,1:maxLen)=Routes{end-i+1,1};
                obj(i)=Routes{end-i+1,2};
            end
            for i=1:nR-R
                j=find(obj==min(obj));
                if length(j)>1
                    j=randsample(j,1);
                end
                P(j,maxLen*i+1:maxLen*(i+1))=Routes{i,1};
                obj(j)=obj(j)+Routes{i,2};
            end
            Feasible=obj<TH;
            AuxObj=0;
            for i=1:R
                if ~Feasible(i)
                    AuxObj=AuxObj+obj(i)+1000;
                else
                    AuxObj=AuxObj+obj(i);            
                end            
            end
            %Mejor hormiga
            if AuxObjBest>AuxObj
                PBest=P;
                objBest=obj;
                AuxObjBest=AuxObj;
            end
            %Arcos visitados
            visitedArc=zeros(n+1,n+1);
            for i=1:R
                for j=1:size(P,2)-1
                    if ~isnan(P(i,j))
                        nodeEx=P(i,j);              %Salida
                    end
                    if ~isnan(P(i,j+1))
                        nodeAr=P(i,j+1);            %Llegada
                        if ~isnan(nodeAr)
                             if nodeEx==0 && nodeAr==0
                                visitedArc(end,end)=1;
                            elseif nodeEx==0
                                visitedArc(end,nodeAr)=1;
                            elseif nodeAr==0
                                visitedArc(end,nodeEx)=1;
                            else 
                                visitedArc(nodeEx,nodeAr)=1;
                            end
                        end
                    end
                end
            end
            %Feromonas hormigas
            DPheromones=DPheromones+(Q/AuxObj)*visitedArc;
        end        
        %Actualizar feromonas
        pheromones=rho*pheromones+DPheromones;
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
    filename="mtVRP_FHenao_ACO"+string(nxlxs)+".xlsx";
    writematrix(nan(R+1,150),filename,'Sheet',instance,'AutoFitWidth',false)
    writematrix([PBest round(objBest,2) Feasible],filename,'Sheet',instance,'AutoFitWidth',false)
    writematrix([round(sum(objBest),2) round(tEnd,2)],filename,'Sheet',instance,'AutoFitWidth',false,'Range',Range)
end