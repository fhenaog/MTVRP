function [S,cst]=SplitR(n,Q,Seq,c,q,Th)
    V=inf(1,n+1);
    V(1)=0;
    P=zeros(1,n+1);
    cost=0;
    T=[0 Seq];
    for i=2:n+1
        j=i;
        load=0;
        while j<=n+1 && load<=Q
            load=load+q(T(j));
            if i==j
                cost=c(1,T(i)) + c(1,T(i));
            else
                cost=cost-c(1,T(j-1))+c(T(j-1)+1,T(j))+c(1,T(j));
            end
            if load<=Q && V(i-1)+cost<V(j) && cost<=Th
                V(j)=V(i-1)+cost;
                P(j)=i-1;
            end
            j=j+1;
        end
    end
    S=[];
    j=n+1;
    while j~=1
        trip=0;
        for k=P(j)+1:j
            trip=[trip T(k)];
        end
        S=[trip S];
        j=P(j);
    end
    S=[S 0];
    cst=V(end);
end