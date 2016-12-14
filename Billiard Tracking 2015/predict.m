% function [S_bar] = predict(S,u,R)
% This function should perform the prediction step of MCL
% Inputs:
%           S(t-1)              4XM
%           v(t)                1X1
%           omega(t)            1X1
%           R                   3X3
%           delta_t             1X1
% Outputs:
%           S_bar(t)            4XM
function [S_bar] = predict(S,R,v)
% FILL IN HERE
    N=size(R,1);
    M=size(S,2);
    diffusion=randn(N,M).*repmat(sqrt(diag(R)),1,M);
    S_bar(1:2,:) = S(1:2,:) + diffusion; % + delta_t * [v*cos(S(3,:));v*sin(S(3,:));repmat(omega,1,M)]     
    S_bar(3,:)=S(3,:);
end