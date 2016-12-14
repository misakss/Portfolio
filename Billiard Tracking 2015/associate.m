% function [outlier,Psi] = associate(S_bar,z,W,Lambda_psi,Q)
%           S_bar(t)            4XM
%           z(t)                2Xn
%           W                   2XN
%           Lambda_psi          1X1
%           Q                   2X2
% Outputs: 
%           outlier             1Xn
%           Psi(t)              1XnXM
function [outlier,Psi] = associate(S_bar,z,Lambda_psi,Q)
% FILL IN HERE
%BE SURE THAT YOUR innovation 'nu' has its second component in [-pi, pi]
    n=size(z,2);
    M=size(S_bar,2);
    Psi=zeros(n,M);
    outlier=zeros(n,M);
    z_hat=S_bar(1:2,:);
    for i=1:n   
%         nu=sqrt(bsxfun(@minus,z(1,i),z_hat(1,:)).^2+bsxfun(@minus,z(2,i),z_hat(2,:)).^2);
        nu=bsxfun(@minus,z(:,i),z_hat);
%         data=[data nu(1,:)];
        Psi(i,:)=(1/(2*pi*sqrt(det(Q))))*exp(-sum(nu.*(Q\nu),1)'/2);
        
        outlier(i)=mean(Psi(i,:))<=Lambda_psi;
    end
%     hist(data,M)
%     pause()
end
