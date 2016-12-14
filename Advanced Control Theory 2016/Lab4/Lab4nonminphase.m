clear all
close all
clc

sysnmp=nonminphase;
[A,B,C,D]=ssdata(sysnmp);
% D=0
s=tf('s');
I=eye(size(A));
Gold=C*((s*I-A)^(-1))*B;
G=zpk(sysnmp);
g11=G(1,1);
g12=G(1,2);
g21=G(2,1);
g22=G(2,2);
G=[g11 g12;g21 g22];

%-------------------------------------------------------------------------
% 3.1 Static Decoupling
%-------------------------------------------------------------------------
% 3.1.1.
% % % W1=inv(evalfr(G,i*0));
% % % Gtilde=minreal(G*W1);
% % % %bode(G)
% % % figure
% % % bode(Gtilde)
% % % title('Non-Minimum Phase - Gtilde Static Decoupling')
% % % 
% % % % 3.1.2.
% % % %margin(Gtilde(1,1)) gives -55 degrees for minimum phase and -7 for non-minimum phase
% % % %margin(Gtilde(2,2)) gives -60 degrees for minimum phase and -8 for non-minimum phase
% % % wc=0.02; % wc=0.02 rad/s for non-minimum phase
% % % fi_m=pi/3;
% % % [mag,phase11]=bode(Gtilde(1,1),wc);
% % % [mag,phase22]=bode(Gtilde(2,2),wc);
% % % arg_g11tilde_wc=phase11*(pi/180); % Change depending on minimum phase or non-minimum phase
% % % arg_g22tilde_wc=phase22*(pi/180); % Change depending on minimum phase or non-minimum phase
% % % T1=(1/wc)*tan(fi_m-pi+(pi/2)-arg_g11tilde_wc); 
% % % T2=(1/wc)*tan(fi_m-pi+(pi/2)-arg_g22tilde_wc); 
% % % l11_temp=Gtilde(1,1)*(1+(1/(s*T1)));
% % % l22_temp=Gtilde(2,2)*(1+(1/(s*T2)));
% % % K1=1/abs(evalfr(l11_temp,i*wc));
% % % K2=1/abs(evalfr(l22_temp,i*wc));
% % % f1tilde=K1*(1+(1/(s*T1)));
% % % f2tilde=K2*(1+(1/(s*T2)));
% % % Ftilde=[f1tilde 0;0 f2tilde];
% % % F=minreal(inv(evalfr(G,i*0))*Ftilde);
% % % 
% % % % 3.1.3.
% % % S=minreal(inv(eye(size(G))+(G*F)));
% % % T=minreal(inv(eye(size(G))+(G*F))*(G*F));
% % % figure
% % % subplot(2,1,1)
% % % sigma(S)
% % % title('Non-Minimum Phase - Static Decoupling - Singular values S')
% % % subplot(2,1,2)
% % % sigma(T)
% % % title('Non-Minimum Phase - Static Decoupling - Singular values T')
% % % figure
% % % bode(G*F)
% % % title('Non-Minimum Phase - Bode Static Decoupling')

% 3.1.4.
% Simulate - Follow the instructions in description of Lab4

%-------------------------------------------------------------------------
% 3.2 Dynamical Decoupling
%-------------------------------------------------------------------------
RGA=evalfr(G,i*0).*pinv(evalfr(G,i*0).'); %u1 --> y1 and u2 --> y2
% RGA-matrix can change depending on minimum phase or non-minimum phase
w11=-g22/g21;
w12=-g12/g11;
w21=-g21/g22;
w22=-g11/g12;

% 3.2.1.
wc=0.02; % wc=0.02 rad/s for non-minimum phase
W1=[w11 1;1 w22]*((10*wc)/(s+(10*wc))); % W1 can change depending on minimum phase or non-minimum phase (see RGA)
W1_proper=isproper(W1)
Gtilde=minreal(G*W1); % Want this to be diagonal
figure
bode(Gtilde)
title('Non-Minimum Phase - Gtilde Dynamic Decoupling')

% 3.2.2.
%margin(Gtilde(1,1)) % Gives -61 degrees for minimum phase and -8 for non-minimum phase
%margin(Gtilde(2,2)) % Gives -63 degrees for minimum phase and -9 for non-minimum phase
fi_m=pi/3;
[mag,phase11]=bode(Gtilde(1,1),wc);
[mag,phase22]=bode(Gtilde(2,2),wc);
arg_g11tilde_wc=phase11*(pi/180); % Change depending on minimum phase or non-minimum phase
arg_g22tilde_wc=phase22*(pi/180); % Change depending on minimum phase or non-minimum phase
T1=(1/wc)*tan(fi_m-pi+(pi/2)-arg_g11tilde_wc); 
T2=(1/wc)*tan(fi_m-pi+(pi/2)-arg_g22tilde_wc); 
l11_temp=Gtilde(1,1)*(1+(1/(s*T1)));
l22_temp=Gtilde(2,2)*(1+(1/(s*T2)));
K1=1/abs(evalfr(l11_temp,i*wc));
K2=1/abs(evalfr(l22_temp,i*wc));
f1tilde=K1*(1+(1/(s*T1)));
f2tilde=K2*(1+(1/(s*T2)));
Ftilde=[f1tilde 0;0 f2tilde];
F=minreal(W1*Ftilde);

% % % % 3.2.3.
% % % S=minreal(inv(eye(size(G))+(G*F)));
% % % T=minreal(inv(eye(size(G))+(G*F))*(G*F));
% % % figure
% % % subplot(2,1,1)
% % % sigma(S)
% % % title('Non-Minimum Phase - Dynamical Decoupling - Singular values S')
% % % subplot(2,1,2)
% % % sigma(T)
% % % title('Non-Minimum Phase - Dynamical Decoupling - Singular values T')
% % % figure
% % % bode(G*F)
% % % title('Non-Minimum Phase - Bode Dynamical Decoupling')

% 3.2.4.
% Simulate - Follow the instructions in description of Lab4

% % % %-------------------------------------------------------------------------
% % % % 3.3 Glover-McFarlane Robust Loop-Shaping
% % % %-------------------------------------------------------------------------
% % % F_temp=W1*Ftilde;
% % % %F_temp=inv(evalfr(G,i*0))*Ftilde;
% % % L0=minreal(G*F_temp); % Use the F that gave best results comparing 3.1 and 3.2

L=Gtilde*Ftilde;
L0=minreal(L);

% 3.3.1.
RGA2=evalfr(G,i*wc).*pinv(evalfr(G,i*wc).'); % wc=0.1 rad/s for minimum phase and wc=0.02 rad/s for non-minimum phase
%bode(L0)

% 3.3.2.
alpha=1.1;
[Fr,gam]=rloop(L0,alpha); % Check if gam (gamma) is OK value
F=minreal(W1*Ftilde*Fr);

% % % % 3.3.3.
% % % S=minreal(inv(eye(size(G))+(G*F)));
% % % T=minreal(inv(eye(size(G))+(G*F))*(G*F));
% % % figure
% % % subplot(2,1,1)
% % % sigma(S)
% % % title('Non-Minimum Phase - Glover-McFarlane - Singular values S')
% % % subplot(2,1,2)
% % % sigma(T)
% % % title('Non-Minimum Phase - Glover-McFarlane - Singular values T')

% 3.3.4.
% Simulate - Follow the instructions in description of Lab4


%.........................................................................
% ALL IMPORTANT STUFF FOR GLOVER-MCFARLANE

% % Gtilde=W2GW1, but usually, and also in this case, W2=I
% w11=-g22/g21;
% w12=-g12/g11;
% w21=-g21/g22;
% w22=-g11/g12;
% %W1=[w11 w12;w21 w22];
% 
% % CASE I
% W1=[1 w12;w21 1];
% 
% %or
% 
% % CASE II
% %W1=[w11 1;1 w22];
% 
% Gtilde=G*W1; % Want this to be diagonal
%
% RGA=evalfr(G,i*0).*pinv(evalfr(G,i*0).');
% RGA=evalfr(G,i*wc).*pinv(evalfr(G,i*wc).');
% % RGA(G) tells us whether we use W1=[1 w12;w21 1] or W1=[w11 1;1 w22]
%
% Ftilde=[f1tilde 0;0 f2tilde]; % f1tilde and f2tilde chosen from specifications of the loop gain
% 
% % L=GF=GW1Ftilde
% 
% % CASE I
% l11=f1tilde*(g11-((g12*g21)/g22));
% %and
% l22=f2tilde*(g22-((g12*g21)/g11));
% 
% %or
% 
% % CASE II
% %l11=f1tilde*(g12-((g11*g22)/g21));
% %and
% %l22=f2tilde*(g21-((g11*g22)/g12));
% 
% L=[l11 0;0 l22];
% 
% % The controller F=W1Ftilde
% 
% % CASE I
% F=[f1tilde (-g21/g22)*f2tilde;(-g12/g11)*f1tilde f2tilde];
% 
% %or
% 
% % CASE II
% %F=[(-g22/g21)*f1tilde f2tilde;f1tilde (-g11/g12)*f2tilde];

%.........................................................................

