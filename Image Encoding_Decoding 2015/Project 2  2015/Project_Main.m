z=mkhwdata(920622);
%[Z,nu]=tdftfast(z);
%plot(nu, abs(Z))

nuc=0;
n=[0:1:262143];%lika l�ng som z-vektorn �r, m�ste n v�ljas
x=(cos(nuc*2*pi.*n)).*z';
Wn1=0.09;%denna spelar roll till sk�rpan F�rklara varf�r den �r vald s�h�r, genom att ta med inzoomat bild p� plot(nu, abs(Z))
N1=8;%spelar ej roll till sk�rpan
[B,A]=butter(N1,Wn1,'low');
[H,W] = freqz(B,A); %Anv�nds till rapport, N=512 (default)
s1=filter(B,A,x);
%plot(W,abs(H))

nuc=1/4;
n=[0:1:262143];%lika l�ng som z-vektorn �r, m�ste n v�ljas
x=(cos(nuc*2*pi.*n)).*z';
Wn2=0.09;%denna spelar roll till sk�rpan F�rklara varf�r den �r vald s�h�r, genom att ta med inzoomat bild p� plot(nu, abs(Z))
N2=8;%spelar ej roll till sk�rpan(riktigt), dock p�verkar den hur brant filtret �r, dvs att "skr�p" kan komma in(se plot freqz)
[B,A]=butter(N2,Wn2,'low');
[H,W] = freqz(B,A); %Anv�nds till rapport, N=512 (default)
s2=filter(B,A,x);
%plot(W,abs(H))

nuc=0.5;
n=[0:1:262143];%lika l�ng som z-vektorn �r, m�ste n v�ljas
x=(cos(nuc*2*pi.*n)).*z';
Wn3=0.09;%denna spelar roll till sk�rpan F�rklara varf�r den �r vald s�h�r, genom att ta med inzoomat bild p� plot(nu, abs(Z))
N3=8;%spelar ej roll till sk�rpan
[B,A]=butter(N3,Wn3,'low');
[H,W] = freqz(B,A); %Anv�nds till rapport, N=512 (default)
s3=filter(B,A,x);
%plot(W,abs(H))

%present_image(s2)

