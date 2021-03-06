setup() ;

%% Part 1.1: convolution

%% Part 1.1.1: convolution by a single filter
%%
% Load an image and convert it to gray scale and single precision
x = im2single(rgb2gray(imread('data/ray.jpg'))) ;

% Define a filter
w = single([
   0 -1  0
  -1  4 -1
   0 -1  0]) ;

% Apply the filter to the image
y = vl_nnconv(x, w, [],'pad',1) ; % 'pad',1 padds zeros to make the image the same size as the input image

%%
% Visualize the results
figure(11) ; clf ; colormap gray ;
set(gcf, 'name', 'Part 1.1: convolution') ;

subplot(2,2,1) ;
imagesc(x) ;
axis off image ;
title('Input image x') ;

subplot(2,2,2) ;
imagesc(w) ;
axis off image ;
title('Filter w') ;

subplot(2,2,3) ;
imagesc(y) ;
axis off image ;
title('Output image y') ;

%% Part 1.1.2: convolution by a bank of filters

% Concatenate three filters in a bank
w1 = single([
   0 -1  0
  -1  4 -1
   0 -1  0]) ;

w2 = single([
  -1 0 +1
  -1 0 +1
  -1 0 +1]) ;

w3 = single([
  -1 -1 -1
   0  0  0
  +1 +1 +1]) ;

wbank = cat(4, w1, w2, w3) ;

% Apply convolution
y = vl_nnconv(x, wbank, []) ;
y = cat(3,y,sqrt(y(:,:,2).^2+y(:,:,3).^2)); % Adding Sobel kernel
% Show feature channels
figure(12) ; clf('reset') ;
set(gcf, 'name', 'Part 1.1.2: channels') ;
colormap gray ;
showFeatureChannels(y) ;

%% Part 1.1.3: convolving a batch of images
%%
x1 = im2single(rgb2gray(imread('data/ray.jpg'))) ;
x2 = im2single(rgb2gray(imread('data/crab.jpg'))) ;
x = cat(4, x1, x2) ;

y = vl_nnconv(x, wbank, []) ;
%% visualize the results
figure(13) ; clf('reset') ;
set(gcf, 'name', 'Part 1.1.3: channels in Im 1') ;
colormap gray ;
showFeatureChannels(y(:,:,:,1));
figure(14) ; clf('reset') ;
set(gcf, 'name', 'Part 1.1.3: channels in Im 2') ;
colormap gray ;
showFeatureChannels(y(:,:,:,2));

% Checking the 4th dimension in y and seeing if the images are stored
% there, which they are

%% Part 1.2: non-linear activation functions (ReLU)

%% Part 1.2.1: Laplacian and ReLU
%%
x = im2single(rgb2gray(imread('data/ray.jpg'))) ;

% Convolve with the negated Laplacian
y = vl_nnconv(x, -w, []) ;

% Apply the ReLU operator
z1 = vl_nnrelu(y);
z2=vl_nnsigmoid(y);
z3=0;
%z3=vl_nntanh(y);?

% Trying different activation functions

%% visualize the results
close all
figure(15) ; clf ; colormap gray ;
set(gcf, 'name', 'Part 1.2.1: ReLU') ;

subplot(3,2,1) ;
imagesc(x) ;
axis off image ;
title('Input image x') ;

subplot(3,2,2) ;
imagesc(y) ;
axis off image ;
title('Output y') ;

subplot(3,2,3) ;
imagesc(z1) ;
axis off image ;
title('After ReLU') ;

subplot(3,2,4) ;
imagesc(z2) ;
axis off image ;
title('After sigmoid') ;

subplot(3,2,5) ;
imagesc(z3) ;
axis off image ;
title('After tanh') ;
%% Part 1.2.2: effect of adding a bias
%%
bias = single(- 0.2) ;
y = vl_nnconv(x, - w, bias) ;
z = vl_nnrelu(y) ;

%% visualize the results
close all
figure(16) ; clf ; colormap gray ;
set(gcf, 'name', 'Part 1.2.2: ReLU+bias') ;

subplot(2,2,1) ;
imagesc(x) ;
axis off image ;
title('Input image x') ;

subplot(2,2,2) ;
imagesc(y) ;
axis off image ;
title('Output y') ;

subplot(2,2,3) ;
imagesc(z) ;
axis off image ;
title('After ReLU with bias') ;
%% Max+avarage pooling
p1=vl_nnpool(x,[2 2]);
p2=vl_nnpool(y,[2 2]);
p3=vl_nnpool(x,[4 4]);
p4=vl_nnpool(y,[4 4]);

close all
figure(17) ; clf ; colormap gray ;
set(gcf, 'name', 'Part 1.2.1: pooling') ;

subplot(2,2,1) ;
imagesc(p1) ;
axis off image ;
title('2x2 on input image x') ;

subplot(2,2,2) ;
imagesc(p2) ;
axis off image ;
title('2x2 on output y') ;

subplot(2,2,3) ;
imagesc(p3) ;
axis off image ;
title('4x4 on input image x') ;

subplot(2,2,4) ;
imagesc(p4) ;
axis off image ;
title('4x4 on output y') ;