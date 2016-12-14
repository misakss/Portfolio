scale_factor = 0.5;          % image downscale factor
area = [ 80, 110, 570, 300 ] % image region to train foreground with
%area = [ 80, 33, 219, 153 ]*2 % tiger2, use alpha=16 e.g.
K = 16; % represent number of gaussians we uses (how well to represent foreground & background   % number of mixture components
alpha = 8.0; % how hard it is to cut neighbours (higher value means harder to cut neighbours     % maximum edge cost
sigma = 10.0; % how large the energy difference is depending on the colour difference            % edge cost decay factor

I = imread('tiger1.jpg');
I = imresize(I, scale_factor);
Iback = I;
area = int16(area*scale_factor);
[ segm, prior ] = graphcut_segm(I, area, K, alpha, sigma);

Inew = mean_segments(Iback, segm);
I = overlay_bounds(Iback, segm);
imwrite(Inew,'result/graphcut1.png')
imwrite(I,'result/graphcut2.png')
imwrite(prior,'result/graphcut3.png')
figure
subplot(2,2,1); imshow(Inew);
subplot(2,2,2); imshow(I);
subplot(2,2,3); imshow(prior);
