clear all
close all
clc

s=tf('s');
B=20;
A=(s+1)*(((s/20)^2)+(s/20)+1);
G=B/A;

Bd=10;
Ad=s+1;
Gd=Bd/Ad;
bodeplot(Gd)

wc=10;
L=wc/s;

%w0=20;
%osc=1;
%new_poles=s^2+2*osc*w0*s+w0^2;

Fy_temp=wc/(s*G); %Not proper
%Fy=Fy_temp*(1/new_poles);
p=100; %The new introduced poles. Chosen large to not affect lower frequencies. We only add these to make system proper, not to have any certain effect.
Fy=Fy_temp*((p/(s+p))^2);
Fy=minreal(Fy);

S_temp=1/(1+Fy*G);
S=minreal(S_temp);
figure
bodeplot(S*Gd) %Should be less than 0 for all frequencies, then we have designed S correctly, since we want to supress the disturbances.
figure
bodeplot(Gd,S)%Shows that we supress the disturbances at right frequencies (lower than 10 rad/s).
legend('Gd','S')
figure
bodeplot(S,1/(1+L)) %Shows that calculated S and definition of S are very similar. The same for low frequencies.

wi=10;
PI=(s+wi)/s;
Fy_PI=(Gd/G)*PI*((p/(s+p))^2);
L_new=minreal(Fy_PI*G);
S_new=minreal(1/(1+L_new));
figure
step(S_new*Gd)

%beta=0.04;
%beta=0.49; This works
beta=0.1;
%wcd=25;
%wcd=22; This works
wcd=0.8;
tau_d=1/(wcd*sqrt(beta));
Flead=(tau_d*s+1)/(beta*tau_d*s+1);
K=sqrt(beta)/abs(evalfr(G,i*wcd));
Fy_lead=K*Flead*Fy_PI;
L_new=minreal(Fy_lead*G);
tau=1;
Fr=1/(1+(tau*s));
%Fr=1;
Gc=(L_new/(1+L_new));
S_new=minreal(1/(1+L_new));
T_new=minreal(L_new/(1+L_new));

figure
% step(Gc*Fr)
% stepinfo(Gc*Fr)

step(minreal((Fr*G)/(1+L_new)))
stepinfo(minreal((Fr*G)/(1+L_new)))

r=Fy_lead*Fr*S_new;
figure
step(r)
d=Fy_lead*Gd*S_new;
figure
step(-d)

figure
bode(S_new)
figure
bode(T_new)
% figure
% step(S_new*Fr*Fy_lead)
% stepinfo(S_new*Fr*Fy_lead)

