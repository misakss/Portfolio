% 1
d = 0.2032; % [m]
d_sh = 0.06858; % [m]
c = 2.99793*(10^8); % Speed of light [m/s]
E = 160*(10^-3); % Peak energy [J]
Ar = pi*(((d/2)^2)-((d_sh/2)^2)); % Reception area, area of telescope, sector area [m^2]
K = (E*c/2)*Ar; % K(lambda = 532 nm), System constant [W*m^3]

 K = K*(10^-9) % [W*km^3]

% 2
Lmoon = 3*(10^-11); % [W/cm^2*nm*sr]
Ar = Ar*(10^4); % [cm^2]
rd = 0.003/2; % [m]
focal_len = 2; % [m]
FOV = rd/focal_len; % [rad]
deltaOmega = pi*(sin(FOV)^2); % [sr]
deltaLambda = 10; % [nm]
Pback = Lmoon*Ar*deltaOmega*deltaLambda % [W]

% 3
R = [0.2:0.1:20];
R1 = R(find(R<=3));
R2 = R(find(R>3));
S = 25; % [sr]
alpha_aer = 0.1; % [1/km]
alpha_mol = 0.01; % [1/km]
beta_aer = alpha_aer/S; % [1/km]
beta_mol = alpha_mol*(3/(8*pi)); % [1/km]
Rpbl = 3; % [km]

% R <= 3
P1 = (K./(R1.^2))*(beta_aer + beta_mol).*exp(-2*(alpha_aer+alpha_mol).*R1); % [W]
% plot(R1,log(P1))
% title('The Return Power')
% xlabel('Range [km]')
% ylabel('Power [W]')
% hold on
R1_spec = [0.2,1,2,3];
P1_spec = (K./(R1_spec.^2))*(beta_aer + beta_mol).*exp(-2*(alpha_aer+alpha_mol).*R1_spec);
disp(['P for R <= 3km :',num2str(P1_spec)])

% R > 3
P2 = (K./(R2.^2))*beta_mol.*exp(-2*(alpha_aer+alpha_mol)*Rpbl).*exp(-2*alpha_mol.*(R2-Rpbl)); % [W]
% plot(R2,log(P2))
% title('The Return Power')
% xlabel('Range [km]')
% ylabel('Power [W]')
% hold off
R2_spec = [3.00001,4];
P2_spec = (K./(R2_spec.^2))*beta_mol.*exp(-2*(alpha_aer+alpha_mol)*Rpbl).*exp(-2*alpha_mol.*(R2_spec-Rpbl));
disp(['P for R > 3km :',num2str(P2_spec)])

figure
plot(R,log([P1,P2]))
title('The Return Power')
xlabel('Range [km]')
ylabel('Power [dBW]')
hold off
grid minor

% 4
Gt = 5750; % [ohm]
Gac = 20.3;
GT = Gt*Gac; % [ohm]
T1 = 0.606;
T2 = 0.656; 
L = T1*T2; % 0 < L < 1
Rio = 240*10^(-3); % [A/W]
M = 150; % Avalanche gain
Ri = Rio*M; % [A/W]
Rv = Ri*GT % [A*ohm/W]
Rv_prim = Rv*L % [A*ohm/W]

% 5
% a)
q = 1.602*(10^-19); % [C]
F = 4.5;
sigma_th_i = 5^(-12); % [A/Hz^(1/2)]
Ids = 7.64*(10^-8); % [A]
Idb = 3.1*(10^-10); % [A]
B = 10*10^6; % [Hz]
sigma_sh_s1 = 2*q*(GT^2)*F*(M^2)*Rio.*(P1+Pback)*L;
sigma_sh_s2 = 2*q*(GT^2)*F*(M^2)*Rio.*(P2+Pback)*L;
sigma_sh_d = 2*q*(GT^2)*(Ids+F*(M^2)*Idb);
sigma_th = sigma_th_i*GT;
sigma_v1 = sigma_sh_s1.^2 + sigma_sh_d^2 + sigma_th^2;
sigma_v2 = sigma_sh_s2.^2 + sigma_sh_d^2 + sigma_th^2;
SNR1 = (Rv*L.*P1)./(sqrt(sigma_v1)*(B^(1/2))); % [V/V]
SNR2 = (Rv*L.*P2)./(sqrt(sigma_v2)*(B^(1/2))); % [V/V]

figure;
SNRv=[SNR1, SNR2];   
plot(R,10*log(SNRv))
grid minor


% b)
% N = sigma_v^2*B;
% disp(['Noise-dominant system-operation mode: ',num2str(K/sqrt(N))])

% 6
[~,in] = find(SNRv>=1);
in_sol = max(in);
%Rmax = R(in_sol) % [km]
P=[P1,P2];
P_Rmax = P(in_sol) % [W]

% 7
PRF = 20; % [Hz]
PRT = 1/PRF; % [s]
V1 = Rv_prim*P1;
V2 = Rv_prim*P2;

N = ceil((100/36.6)^2) % #pulses

% 8
% Praman = Pelastic*10^-3
% Pelastic(0.2km) = 8.65*10^-5W & Praman(0.2km) = 8.65*10^-8W
% Pback_moonlight = 1.52*10^-13W --> OK for night
% Pback_day = 10^-8W (+5 orders), i.e. not possible to operate day-time

% 9
lambda = 532; % [nm]
h = 6.6262*(10^-34); % [J*s]
eta = (Rio*h*c)/(q*lambda)
NEP = sqrt(2*q*(Ids+F*(M^2)*Idb))/(eta*q*lambda*M/(h*c)) % [W/sqrt(Hz)]
NEPs = sqrt(sigma_sh_d^2 + sigma_th^2)/Rv_prim % [W/sqrt(Hz)]

