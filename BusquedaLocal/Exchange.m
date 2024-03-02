function Best=Exchange(S)
    Best=S;
    Best.ThF=true(Best.R,1);
    Best.Z=inf;
    for i=S.R+1:length(S.Sol(:))
        if ~isnan(S.Sol(i))
            for j=i+1:length(S.Sol(:))
                if ~isnan(S.Sol(j)) && S.Sol(i)~=S.Sol(j)
                    SNew=S;
                    SNew.Sol(i)=S.Sol(j);
                    SNew.Sol(j)=S.Sol(i);
                    for k=1:S.R
                        lst=find(~isnan(SNew.Sol(k,:)),1,"last");
                        if SNew.Sol(k,lst)~=0
                            if lst==size(SNew.Sol,2)
                                aux=nan(S.R,1);
                                aux(k)=0;
                                SNew.Sol=[SNew.Sol aux];
                            else
                                SNew.Sol(k,lst+1)=0;
                            end
                        end
                    end
                    SNew=Objective(SNew,"Exchange",[i j]);
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
                    % if SNew.Z<Best.Z
                    %     Best=SNew;
                    % end
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
