function [S]=Objective(SIn,type,nodes)
    S=SIn;
    Th=S.Th;
    Cap=S.Data(1,3);
    S.CapF=1;     
    if ~exist('type','var')   
        for i=1:S.R
            CapR=0;
            for j=1:length(S.Sol(i,:))
                if isnan(S.Sol(i,j))
                    break
                elseif S.Sol(i,j)==0
                    CapR=Cap;
                else
                    CapR=CapR-S.Data(S.Sol(i,j)+2,4);
                end
                S.CapF=CapR>=0;
                if ~S.CapF
                    break
                end
            end
            if ~S.CapF
                break
            end
        end               
    elseif type=="Exchange"
        for i=1:2
            node=nodes(i);
            if S.Sol(node)~=0
                c=ceil(node/S.R);
                f=node-(c-1)*S.R;
                Rt=GetRoutes(S.Sol(f,:),1);
                l=0;
                for k=1:length(Rt)
                    l=l+length(Rt{k})-1;
                    if l>=c
                        Rt=Rt{k}';
                        break
                    end
                end
                CapR=Cap;
                for j=2:length(Rt)-1
                    CapR=CapR-S.Data(Rt(j)+2,4);
                    S.CapF=CapR>=0;
                    if ~S.CapF
                        break
                    end
                end
            end
            if ~S.CapF
                break
            end
        end
    elseif type=="Insert"
        f=nodes(1,1);
        c=nodes(1,2)+1;
        in=nodes(3,1);
        if in==0
            f=nodes(2,1);
            c=nodes(2,2)-1;
        end
        Rt=GetRoutes(S.Sol(f,:),1);
        l=0;
        for k=1:length(Rt)
            l=l+length(Rt{k})-1;
            if l>=c
                Rt=Rt{k}';
                break
            end
        end
        if l==c-1
            Rt=Rt{end};
        end
        CapR=Cap;
        for j=2:length(Rt)-1
            CapR=CapR-S.Data(Rt(j)+2,4);
            S.CapF=CapR>=0;
            if ~S.CapF
                break
            end
        end
    end
    if S.CapF
        S.Z=0;
        S.ZRoute=zeros(S.R,1);
        for i=1:S.R
            S.ZRoute(i)=CalcDistance(S.Sol(i,:),S.Dist);
        end
        S.Z=sum(S.ZRoute);
        S.ThF=S.ZRoute>Th;
        S.ThV=sum(max(S.ZRoute-S.Th,0));
    else
        S.Z=inf;
        S.ThF=true(S.R,1);
        S.ThV=inf;
    end
    S.ZDist=S.Z;
    S.Z=S.ThV;
end
    