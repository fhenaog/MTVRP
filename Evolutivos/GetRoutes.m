function [Routes,RCar]=GetRoutes(Sol,All)    
    Start=find(Sol'==0);
    n=size(Sol,2);
    Routes={};
    RCar=[];
    DAux=Sol';
    if ~exist("All",'var')
        All=0;
    end
    for i=1:length(Start)-1
        in=Start(i);
        fin=Start(i+1);
        RCar=[RCar ceil(in/n)];
        Routes{i}=DAux(in:fin);
    end
    auxi=0;
    for ind=1:length(Routes)
        i=ind-auxi;
        if any(isnan(Routes{i})) || (all(Routes{i}==0) && ~All)
            Routes(i)=[];
            RCar(i)=[];
            auxi=auxi+1;
        end
    end
end