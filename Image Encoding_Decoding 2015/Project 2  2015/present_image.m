function   present_image(signal)

%
%   present_image(signal)
%	
%	signal	- The signal
%	
%
%  present_image:
%     Plot the image from the signal representation used in 
%     EQ1100, Signaler och System, Homework III, Spring 2011.
%     
%     Mats Bengtsson, 3/5 2011
%     Mats Bengtsson, 23/11 2011
%     Joakim Jalden, 17/4 2013 - Changed for 256x256 images
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

signal = (signal+abs(min(signal)))*255./(max(signal)+abs(min(signal)));
im=reshape(signal,length(signal)/256,256);
image(im)
colormap(gray(256))
