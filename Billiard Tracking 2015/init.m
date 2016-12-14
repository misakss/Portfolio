% function [S,R,Q,Lambda_psi] = init(bound,start_pose)
% This function initializes the parameters of the filter.
% Outputs:
%			S(0):			4XM
%			R:				3X3
%			Q:				2X2
%           Lambda_psi:     1X1
%           start_pose:     3X1
function [S,R,Q,Lambda_psi] = init(xsize,ysize)
M = 10000;

S = [rand(1,M)*(xsize-1)+1;
    rand(1,M)*(ysize-1)+1;
    1/M*ones(1,M)];

% S=[rand(1,M)*50+950;
%     rand(1,M)*50+225;
%     1/M*ones(1,M)];

R = diag([750 750]); %process noise covariance matrix
Q = diag([10 10]); % measurement noise covariance matrix
Lambda_psi = 0.000001;

end
