clear;
clc;
close all;


sysmp=minphase;           % Minphase system
sysnmp=nonminphase;       % Nonminphase system

disp('Minphase system')
%%G_bar
disp('Exercise 3.1.1')

G=zpk(sysmp);
%G=zpk(sysnmp);

W2=eye(2);
% Static decoupling
% W1=inv(evalfr(G,0));

% Dynamical decoupling
W1=[1 minreal(-G(1,2)/G(1,1));minreal(-G(2,1)/G(2,2)) 1]
isproper(W1);

G_bar=minreal(G*W1);
evalfr(G_bar,0)
figure(1),bode(G_bar);

%%
disp('Exercise 3.1.2')

pm=pi/3;
wc=0.1;     %mp:0.1 nmp:0.02

[mag,phase]=bode(G_bar(1,1),wc);  % Find phase margin
phase=(pi*phase)/180;             % Convert to rad/s
T11=(tan(-pi+pi/2+pm-phase))/wc;  
l11=G_bar(1,1)*(1+tf(1,[T11 0])); 
[mag,phase]=bode(l11,wc);
K1=inv(mag);
f1=K1*(1+tf(1,[T11 0])); 


[mag,phase]=bode(G_bar(2,2),wc);
phase=(pi*phase)/180;
T22=(tan(-pi+pi/2+pm-phase))/wc;
l22=G_bar(2,2)*(1+tf(1,[T22 0]));
[mag,phase]=bode(l22,wc);
K2=inv(mag);
f2=K2*(1+tf(1,[T22 0]));

F_bar=minreal(append(f1,f2))
%F_bar=minreal ([f1 0;0 f2])
F=minreal(W1*F_bar);               % Controller

%%
disp('Exercise 3.1.3')

S=minreal(inv(W2+G*F));
T=minreal(S*G*F);
figure(2)
subplot(2,1,1),sigma(S),title('Singular Values for S');
subplot(2,1,2),sigma(T),title('Singular Values for T');

%%

disp('Exercise 3.1.4')
% yes coupled
% no, not that good because of the coupling.
%%
disp('Exercise 3.3.1')
L=G_bar*F_bar;
L0=minreal(L);

[Gm1,Pm1,Wcg1,Wcp1]=margin(L0(1,1));
[Gm2,Pm2,Wcg2,Wcp2]=margin(L0(2,2));
disp(['Phase L011 ' num2str(Pm1)]);
disp(['wc L011 ' num2str(Wcp1)]);
disp(['Phase L022 ' num2str(Pm2)]);
disp(['wc L022 ' num2str(Wcp2)]);

figure(4)
subplot(2,1,1),margin(L0(1,1));
subplot(2,1,2),margin(L0(2,2));

disp('Exercise 3.3.2')
alpha=1.1;
[Fr,gam]=rloop(L0,alpha);
disp(['Gamma' num2str(gam)])

F=minreal(W1*F_bar*Fr);

disp('Exercise 3.3.4')
S=minreal(inv(W2+G*F));
T=minreal(S*G*F);
figure(5)
subplot(2,1,1),sigma(S),title('Singular Values for S');
subplot(2,1,2),sigma(T),title('Singular Values for T');

