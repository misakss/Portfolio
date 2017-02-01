% Determine the system constant

%% CONSTANTS
c=3*10^8;

%% SPECIFICATION
E=100*10^(-3);%Joules
PRF=100;%Hz
d_p=0.4*100;%cm
d_sh=0.06858*100;%cm

D=3*10^(-3);%Diameter
f=2;%focal length

M_ph=400;%PHOTODIODE, Multiplication factor
N_ph=4.5;%PHOTODIODE, Excess-noise factor

M_pmt=3*10^6;%

I_d=1*10^(-9);
I_sen=6*10^4;%A/W
VM=39.12;% Km


L_moon=3*10^(-11);%W*cm-2*nm-1*sr-1
L_sun=3*10^(-6);%W*cm-2*nm-1*sr-1
D_lambda_0=10;%nm (interference filter)
D_lambda_R=3;%nm (interference filter)

R_pbl=3;%Km

%% PARAMETERS
Ar=pi*((d_p/2)^2-(d_sh/2)^2);
%alpha_aer=
FOV=D/2/f;

D_Omega=pi*(sin(FOV))^2;



%% EXERCISE 1
K=E*c*Ar/2;%standard units W*m^3
K=K/((10^3)^3);%Transform to W*km^3
disp(['Ex 1: K=', num2str(K)])

%% EXERCISE 2


P_back_E_Q2=L_sun*Ar*D_Omega*D_lambda_0;
P_back_R=L_sun*Ar*D_Omega*D_lambda_R;
disp(['Ex 2: P_back_E=', num2str(P_back_E_Q2)])
disp(['Ex 2: P_back_R=', num2str(P_back_R)])


%% EXERCISE 3
%set radius var: 0:15 Km
R_1=0.2:(R_pbl-0.2)/150:(R_pbl-(R_pbl-0.2)/150);%R_1=0.2:1/10:R_pbl;
R_2=R_pbl:(15-R_pbl)/150:15-(15-R_pbl)/150;%R_2=R_pbl:1/10:15;
R=[R_1, R_2];
%Elastic Channel
N_R=2.1145*10^(34)-2.0022*10^(33)*R + 5.4585*10^(31)*R.^(2);
dsigma_dOmega=3.71*10^(-41);%backscattering cross-section (Km2sr-1)

SM=25;

alpha_aer_E=3.192/VM;%Km-1 alpha_aer_l0
alpha_mol_E_1=1.26*10^(-2).*R_1-7.76*10^(-4)/2*R_1.^2;%alpha_t_l0
alpha_mol_E_2=1.26*10^(-2).*R_2-7.76*10^(-4)/2*R_2.^2;%alpha_t_l0
alpha_aer_R=alpha_aer_E*(607.4/532)^(-1.8);
alpha_mol_R_1=7.32*10^(-3).*R_1-4.52*10^(-4)/2*R_1.^2;%alpha_t_lr
alpha_mol_R_2=7.32*10^(-3).*R_2-4.52*10^(-4)/2*R_2.^2;%alpha_t_lr
% alpha_mol_l0=0.01;%Km-1
beta_aer_E=alpha_aer_E/SM;%beta_aer_l0
beta_mol_E_1=alpha_mol_E_1*3/(8*pi);
beta_mol_E_2=alpha_mol_E_2*3/(8*pi);
beta_mol_R=N_R*dsigma_dOmega;


% beta_r_aer=0.1;
% beta_r_mol=0.01;

T_1=exp(-2*(alpha_aer_E+alpha_mol_E_1).*R_1);
P_E_1=K*R_1.^(-2).*(beta_aer_E+beta_mol_E_1).*T_1;%*B

T_2=exp(-2*(alpha_aer_E+alpha_mol_E_1)*R_pbl-2*(alpha_mol_E_2).*(R_2-R_pbl));
P_E_2=K*R_2.^(-2).*(beta_mol_E_2).*T_2;%*B

P_E=[log(P_E_1), log(P_E_2)];
R=[R_1, R_2];

figure
plot(R,P_E);xlabel('Range [Km]');ylabel('Power [dBW]');
grid minor

%Ramman Channel
O=d_sh/d_p;%overlap factro (m)
T_1=0.6;%Transmissivity T1
T_2=0.65;%Transmissivity T1
L=T_1*T_2;
K_R=K*O/L;

T_R=exp(-2*(alpha_aer_E+[alpha_mol_E_1,alpha_mol_E_2]+alpha_aer_R+[alpha_mol_R_1,alpha_mol_R_2]));
P_R=log(K_R*R.^(-2).*(N_R*dsigma_dOmega).*T_R);

hold on;
plot(R,P_R);

P_back_E=repmat(P_back_E_Q2,size(R));
P_back_R=repmat(P_back_R,size(R));
plot(R,log(P_back_E),'blue--');
plot(R,log(P_back_R),'red--');

%% EXERCISE 4
M_E = 400;
G_T_E = 5750*20.3; % Ohm
G_T_R = 50; % Ohm
Rio = 240*10^3; % mA
Ri_E = Rio*M_E; % mA/W
Ri_R = 6*(10^4); % A/W

Rv_E = Ri_E*G_T_E;
Rv_E_prim = Rv_E*L;

Rv_R = Ri_R*G_T_R;
Rv_R_prim = Rv_R*L;

%% EXERCISE 5

%params
Ids = 7.64*(10^-8); % [A]

q = 1.602*(10^-19); % [C]
F = 4.5;
sigma_th_i = 5; % [pA/Hz^(1/2)]

Idb = 3.1*(10^-10); % [A]
B = 10*10^6; % [Hz]
sigma_sh_s1 = 2*q*(G_T_E^2)*F*(M_E^2)*Rio.*(P_E_1+P_back_E_Q2)*L;
sigma_sh_s2 = 2*q*(G_T_E^2)*F*(M_E^2)*Rio.*(P_E_2+P_back_E_Q2)*L;
sigma_sh_d = 2*q*(G_T_E^2)*(Ids+F*(M_E^2)*Idb);
sigma_th = (sigma_th_i*G_T_E);
sigma_v1 = sqrt(sigma_sh_s1.^2 + sigma_sh_d^2 + sigma_th^2);
sigma_v2 = sqrt(sigma_sh_s2.^2 + sigma_sh_d^2 + sigma_th^2);
SNR1 = (Rv_E*L.*P_E_1)./(sigma_v1*(B^(1/2))); % [V/V]
SNR2 = (Rv_E*L.*P_E_2)./(sigma_v2*(B^(1/2))); % [V/V]

SNR=10*log([SNR1, SNR2]);
figure;
plot(R,SNR);

sigma = [10*log(sigma_sh_s1), 10*log(sigma_sh_s2)];
sigma_sh_d_vec=repmat(log(sigma_sh_d),size(R));
sigma_th_vec = repmat(log(sigma_th),size(R));

hold on;
plot(R,sigma);
plot(R,sigma_sh_d_vec);
plot(R,sigma_th_vec);

title('SNRv')
xlabel('Range [Km]')
ylabel('SNRv')
grid minor

legend('SNRv','sigma','sigma\_sh\_d','sigma\_th')
% hold off
% b)
% N = [sigma_v1,sigma_v2].^2*B;
% disp(['Noise-dominant system-operation mode: ',num2str(K./sqrt(N))])













