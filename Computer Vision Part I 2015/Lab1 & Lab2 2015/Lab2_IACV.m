clear all
close all
clc
%%Setup
tools=few256;
house=godthem256;
phone=phonecalc256;
deltax=[0 0 0;-1 0 1; 0 0 0]/2;
deltay=[0 -1 0; 0 0 0; 0 1 0]/2;
% deltax=[-1 0 1; -2 0 2; -1 0 1];
% deltay=[-1 -2 -1;0 0 0;1 2 1];
%% Question 1
dxtools=conv2(tools, deltax, 'valid');
dytools=conv2(tools, deltay, 'valid');
% subplot(1,2,1)
% showgrey(dxtools);
% title('dxtools')
% subplot(1,2,2)
% showgrey(dytools);
% title('dytools')
% size(tools)
% size(dxtools)

%% Question 2 and 3
% gradmagntools=sqrt(dxtools.^2+dytools.^2);
% thresh=0;
% subplot(2,3,1)
% showgrey(gradmagntools);
% title('merged transitions')
% subplot(2,3,2)
% showgrey(log(1+gradmagntools));
% title('log to enhance')
% subplot(2,3,3)
% showgrey((gradmagntools-thresh)>0);
% title('white is transitions')
% subplot(2,3,4)
% hist(gradmagntools)
% subplot(2,3,5)
% thresh=20;
% showgrey((gradmagntools-thresh)>0);
% title('thresh=20')
% subplot(2,3,6)
% thresh=60;
% showgrey((gradmagntools-thresh)>0);
% title('thresh=60')
% figure
% 
% subplot(2,3,1)
% showgrey(Lv(house));
% subplot(2,3,2)
% hist(Lv(house))
% subplot(2,3,3)
% thresh=20;
% showgrey((Lv(house)-thresh)>0);
% title('thresh=20')
% subplot(2,3,4)
% t=2;
% showgrey(Lv(gaussfft(house,t)));
% subplot(2,3,5)
% hist(Lv(gaussfft(house,t)))
% subplot(2,3,6)
% thresh=15;
% showgrey((Lv(gaussfft(house,t))-thresh)>0);
% title('thresh=15')
%% Question 4, 5 and 6
% scale=[0.0001 1 4 16 64];
% for s=scale
%     subplot(1,length(scale),find(s==scale))
%     contour(Lvvtilde(discgaussfft(house,s),'same'),[0 0]);
%     axis('image')
%     axis('ij')
% end
% 
% figure
% for s=scale
%      subplot(2,length(scale),find(s==scale))
%      showgrey(Lvvvtilde(discgaussfft(tools,s),'same')<0)
%      subplot(2,length(scale),find(s==scale)+length(scale))
%      showgrey(log(1+Lv(discgaussfft(tools,s))))
%      axis('image')
%      axis('ij')
% end

%% Question 7
% overlaycurves(house,extractedge(house,4,15))
% figure
% overlaycurves(tools,extractedge(tools,10,10))

%% Hough
% testimage1 = triangle128;
% smalltest1 = binsubsample(testimage1);
% testimage2=houghtest256;
ntheta=180;
nlines=20;
nrho=2000;
% 
% houghedgeline(testimage1,4,50,nrho,ntheta,nlines);
% 
houghedgeline(house,4,20,nrho,ntheta,nlines,3);
% 
% figure
% houghedgeline(tools,10,10,nrho,ntheta,nlines);  % 8,5 gives a lot of lines in hammer, check for Question 10. 
% 
% figure
% houghedgeline(phone,4,50,nrho,ntheta,nlines);
