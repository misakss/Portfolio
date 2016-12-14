function pixels = Lv(inpic, shape)
if(nargin<2)
        shape='same';
end
dxmask=[-1 0 1]/2;
dymask=([-1 0 1]/2)';
Lx=filter2(dxmask,inpic,shape);
Ly=filter2(dymask,inpic,shape);
pixels=sqrt(Lx.^2+Ly.^2);