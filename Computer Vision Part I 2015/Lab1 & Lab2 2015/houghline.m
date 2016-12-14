function [linepar, acc] = houghline(curves, magnitude, nrho, ...
ntheta, threshold, nlines, verbose)

acc=zeros(nrho,ntheta); 
maxrho=sqrt(size(magnitude,1)^2+size(magnitude,2)^2);
rhoarray=-maxrho:2*maxrho/(nrho-1):maxrho;

insize = size(curves, 2);
trypointer = 1;
numcurves = 0;
while trypointer <= insize
  polylength = curves(2, trypointer);
  numcurves = numcurves + 1;
  trypointer = trypointer + 1;
  
  for polyidx = 1:polylength
    x = round(curves(2, trypointer));
    y = round(curves(1, trypointer));
    if magnitude(x,y)>threshold
        x=x-1-size(magnitude,2)/2;
        y=y-1-size(magnitude,1)/2;
        for theta=-pi/2:pi/(ntheta-1):pi/2
            rho=x*cos(theta)+y*sin(theta);
            indT=round((theta+pi/2)*(ntheta-1)/pi+1);
            [~,indR]=min(abs(rhoarray-rho)); % Find the "fake" rho in our discretized rhoarray that is closest to the true rho value and find that index and put it into acc
            acc(indR,indT)=acc(indR,indT)+1;
        end
    end
    trypointer = trypointer + 1;
  end
end

tmpacc=binsepsmoothiter(acc,0.5,1);

[pos,value]=locmax8(tmpacc);
[~,indexvector]=sort(value);
nmaxima=size(value,1);

linepar=zeros(2,nlines);
outcurves=zeros(2,4*nlines);
for idx=1:nlines
    rhoidxacc=pos(indexvector(nmaxima-idx+1),1);
    thetaidxacc=pos(indexvector(nmaxima-idx+1),2);
    theta=(thetaidxacc-1)*pi/(ntheta-1)-pi/2;
    rho= rhoarray(rhoidxacc);
    linepar(:,idx)=[rho;theta];
    
    x0 = rho*cos(theta)+size(magnitude,2)/2;
    y0 = rho*sin(theta)+size(magnitude,1)/2;
    dx = sin(theta)*size(magnitude,2);
    dy = -cos(theta)*size(magnitude,1);
    outcurves(1, 4*(idx-1) + 1) = 0; % level, not significant
    outcurves(2, 4*(idx-1) + 1) = 3; % number of points in the curve
    outcurves(2, 4*(idx-1) + 2) = x0-dx;
    outcurves(1, 4*(idx-1) + 2) = y0-dy;
    outcurves(2, 4*(idx-1) + 3) = x0;
    outcurves(1, 4*(idx-1) + 3) = y0;
    outcurves(2, 4*(idx-1) + 4) = x0+dx;
    outcurves(1, 4*(idx-1) + 4) = y0+dy;
    if verbose>=2   %show value in acc for the lines
        disp(['acc value: ', num2str(tmpacc(rhoidxacc,thetaidxacc)), ' rho: ', num2str(rho) ...
            ,' theta: ' ,num2str(theta),' x0: ',num2str(x0),' y0: ',num2str(y0)]);
    end
end
if verbose>=1   %show image
    overlaycurves(magnitude,outcurves);
end
if verbose>=3
    figure
    surf(acc);
end

end