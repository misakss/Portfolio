z=mkhwdata(920622);
%[Z,nu]=tdftfast(z);
%plot(nu, abs(Z))

Wn1=0.08;%denna spelar roll till sk�rpan
N1=8;%spelar ej roll till sk�rpan
[B,A]=butter(N1,Wn1,'low');
%[H,W] = freqz(B,A,N1);
s1=filter(B,A,z);
present_image(s1)

Wn2=[0.45,0.65];%denna spelar roll till sk�rpan
N2=4;%spelar ej roll till sk�rpan, s� l�nge den �r under 10(tror jag). Eller s� spelar den visst roll...
[B,A]=butter(N2,Wn2);
[H,W]=freqz(B,A,N2);
s2=filter(B,A,z);

n=[0:1:262144];%lika l�ng som z-vektorn �r, m�ste n v�ljas
%x=((-1).^n)*z;
Wn3=0.9;%denna spelar roll till sk�rpan
N3=8;%spelar ej roll till sk�rpan
[B,A]=butter(N3,Wn3, 'low');
[H,W] = freqz(B,A,N3);
s3=filter(B,A,x);

%present_image(s2)
