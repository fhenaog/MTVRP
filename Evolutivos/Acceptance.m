function bool=Acceptance(Best,SNew)  %si se acepta S2 o no
    bool=false;
    if SNew.Z<Best.Z
        bool=true;
    elseif SNew.Z==Best.Z && SNew.ZDist<Best.ZDist
        bool=true;
    end
end