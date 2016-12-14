clear all; close all; clc;

s = tf('s');
G = 1e4*(s+2)/(s+3)/(s+100)^2;
Hinf(G);

%% Simulation
% Fsim = F; Gsim = G;
% macro % Edit parameters in macro