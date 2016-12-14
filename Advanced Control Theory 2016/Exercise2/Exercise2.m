close all
clear all
clc

sysmp=minphase;
[A,B,C,D]=ssdata(sysmp);
% D=0
s=tf('s');
I=eye(size(A));

% 3.1.1. - Calculate G(s) and each elements poles and zeros
G=C*((s*I-A)^(-1))*B;

pG11=pole(G(1,1));
pG12=pole(G(1,2));
pG21=pole(G(2,1));
pG22=pole(G(2,2));

zG11=tzero(G(1,1));
zG12=tzero(G(1,2));
zG21=tzero(G(2,1));
zG22=tzero(G(2,2));

% 3.1.2. - Calculate poles and zeros of MIMO system G(s)
detG=G(1,1)*G(2,2)-G(1,2)*G(2,1);
pG=pole(detG);
zG=tzero(detG);

% 3.1.3. - Calculate singular values
sigma(G) % Shows the smallest and the largest singular values for different frequencies

% For Hinf make a bode plot of the systems in G(s) and choose the largest
% value. Also convert it from dB. Or use evalfr(G,i*0)
%bode(G)

% 3.1.4. - Calculate RGA of G at w=0
RGA=evalfr(G,i*0).*pinv(evalfr(G,i*0).');

% 3.1.5. - Plot step response of the inputs
figure
step(G) % The steady-state value corresponds to s=0 in RGA

% 3.1.6. - Do the same for non-minimum phase
sysmp=nonminphase;
[A,B,C,D]=ssdata(sysmp);
% D=0
s=tf('s');
I=eye(size(A));


G=C*((s*I-A)^(-1))*B;

pG11=pole(G(1,1));
pG12=pole(G(1,2));
pG21=pole(G(2,1));
pG22=pole(G(2,2));

zG11=tzero(G(1,1));
zG12=tzero(G(1,2));
zG21=tzero(G(2,1));
zG22=tzero(G(2,2));


detG=G(1,1)*G(2,2)-G(1,2)*G(2,1);
pG=pole(detG);
zG=tzero(detG);

figure
sigma(G) % Shows the smallest and the largest singular values for different frequencies

% For Hinf make a bode plot of the systems in G(s) and choose the largest
% value. Also convert it from dB. Or use evalfr(G,i*0)
%bode(G)

RGA=evalfr(G,i*0).*pinv(evalfr(G,i*0).');

figure
step(G) % The steady-state value corresponds to s=0 in RGA

% 3.2.1. - Design of decentralized controller
% Minimum phase
sysmp=minphase;
[A,B,C,D]=ssdata(sysmp);
% D=0
s=tf('s');
I=eye(size(A));
G=C*((s*I-A)^(-1))*B;

wc=0.1; 
fi_m=pi/3;
arg_g11_wc=-62.5*(pi/180);
arg_g22_wc=-65.4*(pi/180);
T1=tan(fi_m-pi+(pi/2)-arg_g11_wc); % margin(G(1,1)) gives arg(g11(iwc)) for equation (2)
T2=tan(fi_m-pi+(pi/2)-arg_g22_wc); % margin(G(2,2)) gives arg(g22(iwc)) for equation (2)
l11=G(1,1)*(1+(1/(s*T1)));
l22=G(2,2)*(1+(1/(s*T2)));
K1=1/abs(evalfr(l11,i*wc));
K2=1/abs(evalfr(l22,i*wc));
f1=K1*(1+(1/(s*T1)));
f2=K2*(1+(1/(s*T2)));
F=[f1 0;0 f2];

% 3.2.2. - S and T and their singular values
S=inv(eye(size(G))+(G*F));
T=inv(eye(size(G))+(G*F))*(G*F);

% Is the following what they mean with "calculate singular values"?

figure
subplot(2,1,1)
sigma(S)
title('Singular values S')
subplot(2,1,2)
sigma(T)
title('Singular values T')

% 3.2.3. - ??

% The same for non-minimum phase

sysmp=nonminphase;
[A,B,C,D]=ssdata(sysmp);
% D=0
s=tf('s');
I=eye(size(A));
G=C*((s*I-A)^(-1))*B;

wc=0.1; 
fi_m=pi/3;
arg_g11_wc=-62.5*(pi/180);
arg_g22_wc=-65.4*(pi/180);
T1=tan(fi_m-pi+(pi/2)-arg_g11_wc); % margin(G(1,1)) gives arg(g11(iwc)) for equation (2)
T2=tan(fi_m-pi+(pi/2)-arg_g22_wc); % margin(G(2,2)) gives arg(g22(iwc)) for equation (2)
l11=G(1,1)*(1+(1/(s*T1)));
l22=G(2,2)*(1+(1/(s*T2)));
K1=1/abs(evalfr(l11,i*wc));
K2=1/abs(evalfr(l22,i*wc));
f1=K1*(1+(1/(s*T1)));
f2=K2*(1+(1/(s*T2)));
F=[f1 0;0 f2];

% 3.2.2. - S and T and their singular values
S=inv(eye(size(G))+(G*F));
T=inv(eye(size(G))+(G*F))*(G*F);

% Is the following what they mean with "calculate singular values"?

figure
subplot(2,1,1)
sigma(S)
title('Singular values S')
subplot(2,1,2)
sigma(T)
title('Singular values T')

% 3.2.3. - ??




