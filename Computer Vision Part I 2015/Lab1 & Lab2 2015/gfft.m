function pixels = gfft(pic, t)

PIC=fftshift(fft2(pic));

[xsize,ysize] = size(PIC);
[x y] = meshgrid(-xsize/2 : xsize/2-1, -ysize/2 : ysize/2-1);

g=(1/(2*pi*t))*exp(-(x.^2+y.^2)/(2*t));

% max(g(:))
% 1/sum(g(:))
G=fftshift(fft2(g));
M=abs(G).*PIC;
surf(x,y,abs(G))

pixels = real(ifft2((M)));