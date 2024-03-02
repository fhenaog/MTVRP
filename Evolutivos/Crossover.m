function C=Crossover(P1,P2)    
    C1=P1;
    C2=P2;
    % i=randi(length(P1.RK)-1);
    % C1.RK=[P1.RK(1:i) P2.RK(i+1:end)];
    % C2.RK=[P2.RK(1:i) P1.RK(i+1:end)];
    t=-1+rand*3;
    C1.RK=P1.RK*t+(1-t)*P2.RK;
    C2.RK=P2.RK*t+(1-t)*P1.RK;
    if rand<=0.5
        C=C1;
    else
        C=C2;
    end
end