function S=fixRoute(S)
    [Rt,RCar]=GetRoutes(S.Sol);
    rtCar=zeros(S.R,1);
    for i=1:length(RCar)
       rtCar(RCar(i))=rtCar(RCar(i))+1;
    end
    if any(rtCar==0)
        cars=find(rtCar==0);
        for k=1:length(cars)
            car=cars(k);
            maxCar=find(rtCar==max(rtCar));
            maxCar=maxCar(1);
            rtmaxCar=find(RCar==maxCar);
            lngthMax=0;
            rtMax=rtmaxCar(1);
            for j=1:length(rtmaxCar)
                rt=rtmaxCar(j);
                lngth=CalcDistance(Rt{rt},S.Dist);
                if lngth>lngthMax
                    lngthMax=lngth;
                    rtMax=rt;
                end
            end
            RCar(rtMax)=car;
            rtCar=zeros(S.R,1);
            for i=1:length(RCar)
               rtCar(RCar(i))=rtCar(RCar(i))+1;
            end
        end
        Sol=cell(size(S.Sol,1),1);
        for i=1:length(Rt)
            r=Rt{i};
            car=RCar(i);
            Sol{car}=[Sol{car} r(1:end-1)];
        end
        for i=1:S.R
            Sol{i}=[Sol{i} 0];
        end       
        S.Sol=RebuildSol(Sol);
        S=Objective(S);
    end    
    stop=1;
    while stop
        if max(rtCar)-min(rtCar)<2
            stop=0;
            break
        end
        car=find(S.ZRoute==min(S.ZRoute));
        car=car(1);
        maxCar=find(rtCar==max(rtCar));
        maxCar=maxCar(1);
        RCarAux=RCar;
        for m=1:length(maxCar)
            if S.ThF(maxCar(m))
                rtmaxCar=find(RCar==maxCar(m));
                lngthMin=inf;
                rtMin=rtmaxCar(1);
                for j=1:length(rtmaxCar)
                    rt=rtmaxCar(j);
                    lngth=CalcDistance(Rt{rt},S.Dist);
                    if lngth<lngthMin
                        lngthMin=lngth;
                        rtMin=rt;
                    end
                end
                RCar(rtMin)=car;
                Sol=cell(size(S.Sol,1),1);
                for i=1:length(Rt)
                    r=Rt{i};
                    car=RCar(i);
                    Sol{car}=[Sol{car} r(1:end-1)];
                end
                for i=1:S.R
                    Sol{i}=[Sol{i} 0];
                end 
                New=S;
                New.Sol=RebuildSol(Sol);
                New=Objective(New);
                if sum(New.ThF)<sum(S.ThF)
                     S=New;
                     stop=1;
                elseif sum(New.ThF)<sum(S.ThF) && New.ThV<S.ThV 
                    S=New;
                    stop=1;
                else
                    RCar=RCarAux;
                    stop=0;
                end
                rtCar=zeros(S.R,1);
                for i=1:length(RCar)
                   rtCar(RCar(i))=rtCar(RCar(i))+1;
                end
            else
                stop=0;
            end
        end
    end
end
      