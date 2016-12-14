function pixels = Lvvvtilde(inpic, shape)
if(nargin<2)
        shape='same';
end
dxmask=[-1 0 1]/2;
dxmask=wextend(2,'zpd',dxmask,2);
dxmask=dxmask(:,2:6);
dymask=[-1 0 1]'/2;
dymask=wextend(2,'zpd',dymask,2);
dymask=dymask(2:6,:);
dxxmask=[1 -2 1];
dxxmask=wextend(2,'zpd',dxxmask,2);
dxxmask=dxxmask(:,2:6);
dyymask=[1 -2 1]';
dyymask=wextend(2,'zpd',dyymask,2);
dyymask=dyymask(2:6,:);

dxxxmask=filter2(dxxmask,dxmask,shape);
dyyymask=filter2(dyymask,dymask,shape);
dxyymask=filter2(dyymask,dxmask,shape);
dxxymask=filter2(dxxmask,dymask,shape);

Lxxx=filter2(dxxxmask,inpic,shape);
Lyyy=filter2(dyyymask,inpic,shape);
Lx=filter2(dxmask,inpic,shape);
Ly=filter2(dymask,inpic,shape);
Lxxy=filter2(dxxymask,inpic,shape);
Lxyy=filter2(dxyymask,inpic,shape);

pixels=Lx.^3.*Lxxx+3*Lx.^2.*Ly.*Lxxy+3*Lx.*Ly.^2.*Lxyy+Ly.^3.*Lyyy;