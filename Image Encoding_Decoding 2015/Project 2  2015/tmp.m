z=mkhwdata(920622);
%[Z,nu]=tdftfast(z);
%plot(nu, abs(Z))

Wn1=0.08;%denna spelar roll till skärpan
N1=8;%spelar ej roll till skärpan
[B,A]=butter(N1,Wn1,'low');
%[H,W] = freqz(B,A,N1);
s1=filter(B,A,z);
present_image(s1)

Wn2=[0.45,0.65];%denna spelar roll till skärpan
N2=4;%spelar ej roll till skärpan, så länge den är under 10(tror jag). Eller så spelar den visst roll...
[B,A]=butter(N2,Wn2);
[H,W]=freqz(B,A,N2);
s2=filter(B,A,z);

n=[0:1:262144];%lika lång som z-vektorn är, måste n väljas
%x=((-1).^n)*z;
Wn3=0.9;%denna spelar roll till skärpan
N3=8;%spelar ej roll till skärpan
[B,A]=butter(N3,Wn3, 'low');
[H,W] = freqz(B,A,N3);
s3=filter(B,A,x);

%present_image(s2)
