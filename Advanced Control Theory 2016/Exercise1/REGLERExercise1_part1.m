clear all
close all
clc

s=tf('s');
B=3*(1-s);
A=(5*s+1)*(10*s+1);
G=B/A;
margin(G);

beta=0.51; %10(+8 degrees for lag) degrees more margin since G has 20 degrees Pm at wc
beta2=0.23; %for 30(+8 degrees for lag) degrees more margin since G has 20 degrees Pm at wc
wc=0.4; % 0.4 rad/s
tau_d=1/(wc*sqrt(beta2));
tau_i=10/wc;
gamma=0;
F_lead=(tau_d*s+1)/(beta2*tau_d*s+1);
F_lag=(tau_i*s+1)/(tau_i*s+gamma);
F_temp=F_lead*F_lag;
K=sqrt(beta2)/abs(evalfr(G,i*wc));
F=K*F_temp;
Go=F*G;
figure
margin(Go);
Gc=(Go)/(1+(Go));
wb=bandwidth(Gc);
figure
margin(Gc);
Mt=20*log10(getPeakGain(Gc));
stepinfo(Gc)
step(Gc)
