% function [c,outlier, nu_bar, H_bar] = batch_associate(mu_bar,sigma_bar,z,M,Lambda_m,Q)
% This function should perform the maximum likelihood association and outlier detection.
% Note that the bearing error lies in the interval [-pi,pi)
%           mu_bar(t)           3X1
%           sigma_bar(t)        3X3
%           Q                   2X2
%           z(t)                2Xn
%           M                   2XN
%           Lambda_m            1X1
% Outputs: 
%           c(t)                1Xn
%           outlier             1Xn
%           nu_bar(t)           2nX1
%           H_bar(t)            2nX3
function [c,outlier, nu_bar, H_bar] = batch_associate(mu_bar,sigma_bar,z,M,Lambda_m,Q)
% FILL IN HERE
    n=size(z,2);
    N=size(M,2);
    z_hat=zeros(2,N);
    H=zeros(2,3,N);
    S=zeros(2,2,N);
    c=zeros(1,n);
    outlier=zeros(1,n);
    nu_bar=zeros(2,n);
    H_bar=zeros(2,3,n);
    nu=zeros(2,N);
    D=zeros(1,N);
    gauss=zeros(1,N);
    for i=1:n
        for j=1:N
            x=mu_bar;
            alpha=atan2(M(2,j)-x(2),M(1,j)-x(1))-x(3);
            h=[sqrt((M(1,j)-x(1))^2+(M(2,j)-x(2))^2);mod(alpha+pi,2*pi)-pi];
            z_hat(:,j)=h;
            H(:,:,j)=[(mu_bar(1)-M(1,j))/z_hat(1,j) (mu_bar(2)-M(2,j))/z_hat(1,j) 0;
            -(mu_bar(2)-M(2,j))/(z_hat(1,j)^2) (mu_bar(1)-M(1,j))/(z_hat(1,j)^2) -1];
            S(:,:,j)=H(:,:,j)*sigma_bar*H(:,:,j)'+Q;
            nu(:,j)=z(:,i)-z_hat(:,j);
            nu(2,j)=mod(nu(2,j)+pi,2*pi)-pi;
            D(j)=nu(:,j)'*(S(:,:,j)^(-1))*nu(:,j);
            gauss(j)=(det(2*pi*S(:,:,j))^(-1/2))*exp(-D(j)/2);
        end
        c(i)=find(gauss==max(gauss));
        if D(c(i))>= Lambda_m
            outlier(i)=1;
        else
            outlier(i)=0;
        end
        nu_bar(:,i)=nu(:,c(i));
        H_bar(:,:,i)=H(:,:,c(i));
    end
    nu_bar=nu_bar(:);
    testH=zeros(2*n,3);
    for i=1:n
        testH(2*i-1:2*i,:)=H_bar(:,:,i);
    end
    H_bar=testH;
end