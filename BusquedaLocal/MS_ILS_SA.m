function [Best, time, it]=MS_ILS_SA(instance,nsol,nPert,L,To,Tf,r,tl)
    tStart=tic;
    filename=mfilename('fullpath');
    [path,~,~] = fileparts(filename);
    txt=importdata(path+"\mtVRP Instances\"+instance+".txt");
    BestSols=cell(nsol,1);
    [S.Sol, S.ZRoute, S.ThF]=ACO(txt,50,1,1,3,0.5,500,5);
    S=Complete(S,txt); 
    %BestSols{1}=VND_IS(S);
    BestSols{1}=LS(S,1);
    if nsol>1
        for i=2:nsol
            [S.Sol, S.ZRoute, S.ThF]=GRASP(txt,5,100,5);
            S=Complete(S,txt); 
            %BestSols{i}=VND_IS(S);
            BestSols{i}=LS(S,1);
        end
    end
    for i=1:nsol
        BestSols{i}=Objective(BestSols{i});
    end
    CurSols=BestSols;
    time=toc(tStart);
    it=0;
    while time<tl
        T=To;
        while T>Tf && time<tl
            l=0;
            while l<L && time<tl   
                it=it+1;
                l=l+1;
                for i=1:nsol                    
                    NewSol=Perturbation(CurSols{i},nPert);
                    %NewSol=VND_IS(NewSol);
                    NewSol=LS(NewSol,1);
                    NewSol=Objective(NewSol);
                    %d=NewSol.Z-CurSols{i}.Z+max(sum(NewSol.ThF)-sum(CurSols{i}.ThF),0)*500;
                    d=NewSol.Z-CurSols{i}.Z;
                    if d<=0 && NewSol.CapF
                        CurSols{i}=NewSol;
                        % if sum(NewSol.ThF)<sum(BestSols{i}.ThF)
                        %     BestSols{i}=NewSol;                            
                        % elseif sum(NewSol.ThF)==sum(BestSols{i}.ThF) && NewSol.Z<BestSols{i}.Z
                        %     BestSols{i}=NewSol;                            
                        % end
                        if NewSol.Z<BestSols{i}.Z
                            BestSols{i}=NewSol;                            
                        elseif d==0 && NewSol.ZDist<BestSols{i}.ZDist
                            BestSols{i}=NewSol;                            
                        end
                    elseif NewSol.CapF
                        if rand<exp(-d/T)
                            CurSols{i}=NewSol; 
                        end
                    end
                    time=toc(tStart);
                    if time>tl
                        break
                    end
                end 
            end
            T=r*T;
        end
    end
    Best=Objective(BestSols{1});
    for i=1:nsol
        Cand=Objective(BestSols{i});
        if sum(Cand.ThF)<sum(Best.ThF)
            Best=BestSols{i};
        elseif sum(Cand.ThF)==sum(Best.ThF) && BestSols{i}.Z<Best.Z
            Best=BestSols{i};
        end
    end
end