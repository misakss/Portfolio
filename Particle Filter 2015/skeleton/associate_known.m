% function [outlier,Psi] = associate_known(S_bar,z,W,Lambda_psi,Q,known_associations)
%           S_bar(t)            4XM
%           z(t)                2Xn
%           W                   2XN
%           Lambda_psi          1X1
%           Q                   2X2
%           known_associations  1Xn
% Outputs: 
%           outlier             1Xn
%           Psi(t)              1XnXM
function [outlier,Psi] = associate_known(S_bar,z,W,Lambda_psi,Q,known_associations)
% FILL IN HERE
%BE SURE THAT YOUR innovation 'nu' has its second component in [-pi, pi]
% also notice that you have to do something here even if you do not have to maximize the likelihood.
    size_W=size(W,2);
    n=size(z,2);
    M=size(S_bar,2);
    outlier=zeros(1,n);
    Psi=zeros(1,n,M);
    Psi_test=zeros(n,size_W,M);
    index=zeros(size(n));
    for i=1:n
        for k=1:size_W
            z_hat1=sqrt((W(1,k)-S_bar(1,:)).^2+(W(2,k)-S_bar(2,:)).^2);
            z_hat2=atan2(W(2,k)-S_bar(2,:),W(1,k)-S_bar(1,:))-S_bar(3,:);
            z_hat=[z_hat1;z_hat2];
            nu=repmat(z(:,i),1,M)-z_hat;
            nu(2,:)=mod(nu(2,:)+pi,2*pi)-pi;
            Psi_test(i,k,:)=(1/(2*pi*sqrt(det(Q))))*exp(-sum(nu.*(Q\nu),1)'/2);
        end
        [Psi_sort sort_index]=sort(Psi_test(i,:,:),'descend');
        Psi(1,i,:)=Psi_sort(1,1,:);
        index(i)=sort_index(1);
        outlier(i)=mean(Psi(1,i,:))<=Lambda_psi;
    end
    if any(sort(index)~=known_associations)
        landmarks=find(index~=known_associations);
    end
end

