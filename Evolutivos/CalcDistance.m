function obj=CalcDistance(Route,Dist)
    n=length(Route);
    obj=0;
    for i=1:n-1
        ex=Route(i)+1;
        arr=Route(i+1);
        if isnan(arr)
            break
        end
        if arr~=ex-1
            if arr==0
                obj=obj+Dist(arr+1,ex-1);
            else
                obj=obj+Dist(ex,arr);
            end 
        end
    end
end