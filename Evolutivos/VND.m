function [Best, time, it]=VND(instance,tl)
    tStart=tic;
    filename=mfilename('fullpath');
    [path,~,~] = fileparts(filename);
    txt=importdata(path+"\mtVRP Instances\"+instance+".txt");
    [S.Sol, S.ZRoute, S.ThF]=ACO(txt,50,1,1,3,0.5,500,1);
    %[S.Sol, S.ZRoute, S.ThF]=Constructivo(txt);
    S=Complete(S,txt);
    S=ObjectiveVND(S);
    Best=S;
    k=1;    
    it=0;
    time=toc(tStart);
    while k<=5 && time<tl        
        if k==1
            SNew=TwoOptVND(Best);
            SNew=rmfield(SNew,'Zi');            
        elseif k==2
            SNew=Insert(Best);         
        elseif k==3
            SNew=Exchange(Best);
        elseif k==4
            SNew=SwapRoutesVND(Best);
        elseif k==5
            SNew=SplitRouteVND(Best);
        end 
        SNew=ObjectiveVND(SNew);
        if SNew.CapF
            if SNew.Z<Best.Z
                Best=SNew;        
                k=1;
            elseif SNew.Z==Best.Z && SNew.ZDist<Best.ZDist
                Best=SNew;
                k=1;
            else
                k=k+1;
            end
        else
            k=k+1;
        end
        it=it+1;
        time=toc(tStart);
    end
end