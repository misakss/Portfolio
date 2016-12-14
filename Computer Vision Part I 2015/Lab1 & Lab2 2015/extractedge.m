function edgecurves = extractedge(inpic, scale, threshold, shape)
    if nargin<4
        shape='same';
    end
    if nargin<3
        zero=Lvvtilde(discgaussfft(inpic, scale), shape);
        gradmagn=Lv(inpic);
        gradmagn(Lvvvtilde(discgaussfft(inpic,scale),shape)>=0)=-1;
        edgecurves=zerocrosscurves(zero,gradmagn);
    else
        zero=Lvvtilde(discgaussfft(inpic, scale), shape);
        gradmagn=Lv(inpic);
        gradmagn(Lvvvtilde(discgaussfft(inpic,scale),shape)>=0)=0;
        mask=(gradmagn-threshold)-1;
        edgecurves=zerocrosscurves(zero,mask);
    end
end