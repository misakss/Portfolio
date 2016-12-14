function [linepar, acc] = houghedgeline(pic, scale, gradmagnthreshold, ...
nrho, ntheta, nlines, verbose)
magnitude=Lv(pic);
curves=extractedge(pic,scale,gradmagnthreshold);
if nargin<7
    verbose=2;
end
[linepar, acc]=houghline(curves,magnitude,nrho,ntheta,gradmagnthreshold,nlines,verbose);
end