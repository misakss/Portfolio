function pixels = gaussfft(pic, t)

PIC=(fft2(pic));

[xsize,ysize] = size(PIC);
[x, y] = meshgrid(-xsize/2:xsize/2-1, -xsize/2:ysize/2-1);
%[x y] = meshgrid(0 : xsize-1, 0 : ysize-1);

g=(1/(2*pi*t))*exp(-(x.^2+y.^2)/(2*t));

G=fft2(g);
M=abs(G).*PIC;
surf(x,y,fftshift(abs(G)))
pixels = real(ifft2((M)));