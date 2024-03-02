function Best=LS(S,~)
    %Best=S;
    Best=removeDeposits(S);
    k=1;
    while k<=2
        if k==1
            SNew=TwoOpt(Best);
        elseif k==2
            SNew=SwapRoutes(Best);
        end
        if SNew.CapF
            SNew=Objective(SNew);
            % if sum(SNew.ThF)<sum(Best.ThF)
            %     Best=SNew;
            % elseif SNew.Z<Best.Z && sum(SNew.ThF)==sum(Best.ThF)
            %     Best=SNew; 
            % else
            %     break
            % end
            if SNew.Z<Best.Z
                Best=SNew;
            elseif SNew.Z==Best.Z && SNew.ZDist<Best.ZDist
                Best=SNew;  
            else
                k=k+1;
            end
        else
            k=k+1;
        end
    end
end