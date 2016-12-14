clear all
close all
clc

p=7;
q=4;
SIZE=128;

%fftwave(p,q,SIZE)
%% 1-6

% figure
% fftwave(9,5)
% figure
% fftwave(17,9)
% figure
% fftwave(17,121)
% figure
% fftwave(5,1)
% figure
% fftwave(124,1)

%% 7-9

% F=[ zeros(56,128); ones(16,128); zeros(56,128)];
% G=F';
% H=F+2*G;
% 
% subplot(3,1,1)
% showgrey(F);
% subplot(3,1,2)
% showgrey(G);
% subplot(3,1,3)
% showgrey(H);
% 
% Fhat=fft2(F);
% Ghat=fft2(G);
% Hhat=fft2(H);
% 
% figure
% subplot(3,1,1)
% showgrey(log(1+abs(Fhat)));
% subplot(3,1,2)
% showgrey(log(1+abs(Ghat)));
% subplot(3,1,3)
% showgrey(log(1+abs(Hhat)));
% 
% figure
% showfs(Hhat);
% 
% figure
% showgrey(abs(fftshift(Hhat)));

%% 10
%  F=[ zeros(56,128); ones(16,128); zeros(56,128)];
%  G=F';
%  G=[zeros(32,128);ones(64,128);zeros(32,128)]';
%  showgrey(F.*G);
%  figure
%  showfs(fft2(F.*G));
%  figure
%  A=log(1+abs((1/(128^2))*conv2(fft2(F),fft2(G)))); %conv makes it 4 times too big
%  showgrey(fftshift(A(1:end/2,1:end/2)));

%% 11-12
% figure
% F=[zeros(60,128); ones(8,128); zeros(60,128)].*[zeros(128,48) ones(128,32) zeros(128,48)];
% showgrey(F);
% figure
% showfs(fft2(F));

% alpha=30;
% figure
% G=rot(F,alpha);
% showgrey(G);
% axis on
% figure
% Ghat=fft2(G);
% showfs(Ghat);
% figure
% Hhat=rot(fftshift(Ghat),-alpha);
% showgrey(log(1+abs(Hhat)));

%% 13

a=phonecalc128;
b=few128;
c=nallo128;
% subplot(1,3,1)
% showgrey(a);
% subplot(1,3,2)
% showgrey(pow2image(a,10^-10));
% subplot(1,3,3)
% showgrey(randphaseimage(a))
% 
% figure
% subplot(1,3,1)
% showgrey(b);
% subplot(1,3,2)
% showgrey(pow2image(b,10^-10));
% subplot(1,3,3)
% showgrey(randphaseimage(b))
% 
% figure
% subplot(1,3,1)
% showgrey(c);
% subplot(1,3,2)
% showgrey(pow2image(c,10^-10));
% subplot(1,3,3)
% showgrey(randphaseimage(c))

%% 14-16

%showgrey(gaussfft(b,125))
%psf=gaussfft(deltafcn(128,128),200);
%showgrey(psf)
%v=variance(psf)
%showgrey(v)

% for i=[1 4 16 64 256]
%     figure
%     subplot(3,1,1)
%     showgrey(gaussfft(a,i))
%     subplot(3,1,2)
%     showgrey(gaussfft(b,i))
%     subplot(3,1,3)
%     showgrey(gaussfft(c,i))
% end

%% 17-18

office = office256;

% add = gaussnoise(office,16);
% sap = sapnoise(office,0.1,255);
% subplot(2,1,1)
% showgrey(add)
% subplot(2,1,2)
% showgrey(sap)
% figure
% subplot(2,1,1)
% showgrey(discgaussfft(add,4))
% subplot(2,1,2)
% showgrey(discgaussfft(sap,4))
% figure
% subplot(2,1,1)
% showgrey(medfilt(add,5))
% subplot(2,1,2)
% showgrey(medfilt(sap,5))
% figure
% subplot(2,1,1)
% showgrey(ideal(add,0.085,'l'))
% subplot(2,1,2)
% showgrey(ideal(sap,0.085,'l'))

%% 19-20
figure
img=hand256;
t=17;
smoothimg = gaussfft(img,t);
% fc=0.099;
% smoothimg = ideal(img,fc,'l');
N=5;
for i=1:N
    if i>1
        img = rawsubsample(img);
        smoothimg=rawsubsample(smoothimg);
    end
    subplot(2,N,i)
    showgrey(img)
    subplot(2,N,i+N)
    showgrey(smoothimg)
end







