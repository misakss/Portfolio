function dx = l1LossBackward(x,r,p)
% TODO: Replace the following line with your implementation
% dx = rand(size(x), 'like', x) ;
delta = x - r ;
dx = p*((delta>0)*2 - 1);

dx = dx / (size(x,1) * size(x,2)) ;  % normalize by image size