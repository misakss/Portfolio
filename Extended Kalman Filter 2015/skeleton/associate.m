% function [c,outlier, nu, S, H] = associate(mu_bar,sigma_bar,z_i,M,Lambda_m,Q)
% This function should perform the maximum likelihood association and outlier detection.
% Note that the bearing error lies in the interval [-pi,pi)
%           mu_bar(t)           3X1
%           sigma_bar(t)        3X3
%           Q                   2X2
%           z_i(t)              2X1
%           M                   2XN
%           Lambda_m            1X1
% Outputs: 
%           c(t)                1X1
%           outlier             1X1
%           nu^i(t)             2XN
%           S^i(t)              2X2XN
%           H^i(t)              2X3XN
function [c,outlier, nu, S, H] = associate(mu_bar,sigma_bar,z_i,M,Lambda_m,Q)
% FILL IN HERE
    N=size(M,2);
    H=zeros(2,3,N);
    z_hat=zeros(2,N);
    gauss=zeros(1,N);
    nu=zeros(2,N);
    S=zeros(2,2,N);
    for j=1:N        
        x=mu_bar;
        alpha=atan2(M(2,j)-x(2),M(1,j)-x(1))-x(3);
        h=[sqrt((M(1,j)-x(1))^2+(M(2,j)-x(2))^2);mod(alpha+pi,2*pi)-pi];
        z_hat(:,j)=h;
        H(:,:,j)=[(mu_bar(1)-M(1,j))/z_hat(1,j) (mu_bar(2)-M(2,j))/z_hat(1,j) 0;
        -(mu_bar(2)-M(2,j))/(z_hat(1,j)^2) (mu_bar(1)-M(1,j))/(z_hat(1,j)^2) -1];      
        S(:,:,j)=H(:,:,j)*sigma_bar*H(:,:,j)'+Q;
        nu(:,j)=z_i-z_hat(:,j);
        nu(2,j)=mod(nu(2,j)+pi,2*pi)-pi;    
        gauss(j)=exp(-0.5*nu(:,j)'*((S(:,:,j)^(-1)))*nu(:,j))*(det(2*pi*S(:,:,j))^(-1/2));
    end
    [value, c]=max(gauss);
    D=nu(:,c)'*(S(:,:,c)^(-1))*nu(:,c);    
    outlier=D>=Lambda_m;
end