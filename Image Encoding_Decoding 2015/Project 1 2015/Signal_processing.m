close all
clear all
clc

load rockabilly
Y=fft(y);
Nn=5;
Wn=0.99;
[B,A]=butter(Nn,Wn,'high');
z=filter(B,A,y);
Z=fft(z);
plot(abs(y))
%Här ser vi att högst frekvens(sync) har högst energi och nollor lägst 
%frekvens med minst engergi. Vi ser även att det är mer nollor än ettor.
%plot(abs(z))
%Här avläser vi "svaret". Som tidigare nämnt har syncen mer energi
%dvs högre amplitud. Vi ser då att koden är 010100.