% [Y,nu]=tdftfast(y)   
%
%	Calculates the TDFT at a number of discrete frequencies in the
%	interval [-0.5,0.5], for a  discrete time signal y of finite
%	length. 
%       ( utilizes the  function fft.m )
%		
function [Y,nu]=tdftfast(y)

Y=fft(y);
N=length(y);
nu=[(0:N-1)./N];
Y=fftshift(Y);
nu=fftshift(nu);
nu_index=find(nu>=0.5);
nu(nu_index)=nu(nu_index)-1;
