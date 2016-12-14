z=mkhwdata(920622);
%[Z,nu]=tdftfast(z);
%plot(nu, abs(Z))

nuc=0;
n=[0:1:262143];%lika lång som z-vektorn är, måste n väljas
x=(cos(nuc*2*pi.*n)).*z';
Wn1=0.09;%denna spelar roll till skärpan Förklara varför den är vald såhär, genom att ta med inzoomat bild på plot(nu, abs(Z))
N1=8;%spelar ej roll till skärpan
[B,A]=butter(N1,Wn1,'low');
[H,W] = freqz(B,A); %Används till rapport, N=512 (default)
s1=filter(B,A,x);
%plot(W,abs(H))

nuc=1/4;
n=[0:1:262143];%lika lång som z-vektorn är, måste n väljas
x=(cos(nuc*2*pi.*n)).*z';
Wn2=0.09;%denna spelar roll till skärpan Förklara varför den är vald såhär, genom att ta med inzoomat bild på plot(nu, abs(Z))
N2=8;%spelar ej roll till skärpan(riktigt), dock påverkar den hur brant filtret är, dvs att "skräp" kan komma in(se plot freqz)
[B,A]=butter(N2,Wn2,'low');
[H,W] = freqz(B,A); %Används till rapport, N=512 (default)
s2=filter(B,A,x);
%plot(W,abs(H))

nuc=0.5;
n=[0:1:262143];%lika lång som z-vektorn är, måste n väljas
x=(cos(nuc*2*pi.*n)).*z';
Wn3=0.09;%denna spelar roll till skärpan Förklara varför den är vald såhär, genom att ta med inzoomat bild på plot(nu, abs(Z))
N3=8;%spelar ej roll till skärpan
[B,A]=butter(N3,Wn3,'low');
[H,W] = freqz(B,A); %Används till rapport, N=512 (default)
s3=filter(B,A,x);
%plot(W,abs(H))

%present_image(s2)

