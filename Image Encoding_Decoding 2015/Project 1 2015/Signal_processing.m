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
%H�r ser vi att h�gst frekvens(sync) har h�gst energi och nollor l�gst 
%frekvens med minst engergi. Vi ser �ven att det �r mer nollor �n ettor.
%plot(abs(z))
%H�r avl�ser vi "svaret". Som tidigare n�mnt har syncen mer energi
%dvs h�gre amplitud. Vi ser d� att koden �r 010100.