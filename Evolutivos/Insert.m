function Best=Insert(S)
    Best=S;
    Best.ThF=true(Best.R,1);
    Best.Z=inf;
    Routes=cell(S.R,1);
    for i=1:S.R
        Routes{i}=S.Sol(i,~isnan(S.Sol(i,:)));
    end
    AuxRoutes=Routes;
    for i=1:S.R
        for j=2:length(AuxRoutes{i})-1
            for k=i:S.R
                for m=1:length(AuxRoutes{k})
                    Routes=AuxRoutes;
                    if (m>j || k~=i) && S.Sol(i,j)~=S.Sol(k,m) && S.Sol(i,j)~=0 && S.Sol(k,m)~=0 
                        SNew=S;
                        if m==length(AuxRoutes{k})
                            Routes{k}=[Routes{k}(1:m) Routes{i}(j) 0];
                        else
                            Routes{k}=[Routes{k}(1:m) Routes{i}(j) Routes{k}(m+1:end)];
                        end
                        in=Routes{i}(j);
                        Routes{i}(j)=[];
                        SNew.Sol=RebuildSol(Routes);
                        SNew=ObjectiveVND(SNew,"Insert",[k m;i j;in 0]);
                        if SNew.CapF
                            % if sum(SNew.ThF)<sum(Best.ThF)
                            %     Best=SNew;
                            % elseif SNew.Z<Best.Z && sum(SNew.ThF)==sum(Best.ThF)
                            %     Best=SNew;
                            % end
                            if SNew.Z<Best.Z
                                Best=SNew;                            
                            elseif SNew.Z==Best.Z && SNew.ZDist<Best.ZDist
                                Best=SNew;
                            end
                        end
                    end
                end
            end
        end
    end
    for i=1:Best.R
        for j=2:length(Best.Sol(i,:))
            if Best.Sol(i,j)==Best.Sol(i,j-1)
                Best.Sol(i,j-1:end)=[Best.Sol(i,j:end) NaN];
            end
        end
    end
    [~,AuxNaN]=find(~isnan(Best.Sol));
    Aux=max(AuxNaN);
    Best.Sol=Best.Sol(:,1:Aux);
end