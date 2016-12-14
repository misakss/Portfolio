function prob=mixture_prob(image,K,L,mask)
    Ivec=single(reshape(image,size(image,1)*size(image,2),3));
    c=Ivec(mask(:)==1,:);
    N=size(c,1);
    [segm,mu]=kmeans_segm(c,K,L,14);
    cov=cell(K,1);
    cov(:)={diag([10,10,10]).^2};
    w=zeros(1,K);
    for k=1:K
        w(k)=sum(segm==k)/N;
    end
    g_ik=zeros(N,K);
    for l=1:L
        %Expectation
        for k=1:K
            meanmu=(bsxfun(@minus,c,mu(k,:)))'; %Make meanmu 3*N to be able to multiply with cov, Ivec instead of c to use every pixel in image?
            g_ik(:,k)=(1/sqrt(det(cov{k})*(2*pi)^3))*exp(-sum(meanmu.*(cov{k}\meanmu),1)'/2);
        end
        tmp=bsxfun(@times,w,g_ik);
        P_ik=bsxfun(@rdivide,tmp,sum(tmp,2));
        %Maximization
        w=sum(P_ik,1)/N;
        mu(:,1)=sum(bsxfun(@times,P_ik,c(:,1)),1);
        mu(:,2)=sum(bsxfun(@times,P_ik,c(:,2)),1);
        mu(:,3)=sum(bsxfun(@times,P_ik,c(:,3)),1);
        mu=bsxfun(@rdivide,mu,sum(P_ik,1)');

        for k=1:K
            cov{k}=zeros(3);
            meanmu=bsxfun(@minus,c,mu(k,:));
            meanmu2=reshape(meanmu,size(meanmu,1),1,3);
            cov{k}=squeeze(sum(bsxfun(@times,P_ik(:,k),bsxfun(@times,meanmu,meanmu2))))/sum(P_ik(:,k));
        end
%         for k=1:K
%             meanmu=bsxfun(@minus,Ivec,mu(k,:));
%          cov{k}=sum(P_ik(:,k));
%         end
    end
    g_ik=zeros(size(Ivec,1),K);
    for k=1:K
        meanmu=(bsxfun(@minus,Ivec,mu(k,:)))';
        g_ik(:,k)=(1/sqrt(det(cov{k})*(2*pi)^3))*exp(-sum(meanmu.*(cov{k}\meanmu),1)'/2);
    end
    prob=sum(bsxfun(@times,w,g_ik),2);
end

% function prob=mixture_prob(image,K,L,mask)
%     Ivec=single(reshape(image,size(image,1)*size(image,2),3));
%     c=Ivec(mask(:)==1,:);
%     N=size(c,1);
%     [segm,mu]=kmeans_segm(c,K,L,13);
%     cov=cell(K,1);
%     cov(:)={10000*eye(3)};
%     w=zeros(K,1);
%     for k=1:K
%         w(k)=sum(segm==k)/N;
%     end
%     g_ik=zeros(N,K);
%     for i=1:L
%         %Expectation
%         for k=1:K
%             smu=(bsxfun(@minus,c,mu(k,:)))'; %Make smu 3*N to be able to multiply with cov
%             g_ik(:,k)=(1/sqrt(det(cov{k})*(2*pi)^3))*exp(-sum(smu.*(cov{k}\smu),1)'/2);
%         end
%         tmp=bsxfun(@times,w',g_ik);
%         P_ik=bsxfun(@rdivide,tmp,sum(tmp,2));
%         %Maximization
%         w=sum(P_ik,1)/N;
%         mu(:,1)=sum(bsxfun(@times,P_ik,c(:,1)),1);
%         mu(:,2)=sum(bsxfun(@times,P_ik,c(:,2)),1);
%         mu(:,3)=sum(bsxfun(@times,P_ik,c(:,3)),1);
%         mu=bsxfun(@rdivide,mu,sum(P_ik,1)');
%         for k=1:K
%             cov{k}=zeros(3);
%             for i=1:N
%                 meanmu=(bsxfun(@minus,c(i,:),mu(k,:)))';
%                 cov{k}=cov{k}+P_ik(i,k)*(meanmu)*(meanmu');
%             end
%             cov{k}=cov{k}/sum(P_ik(:,k));
%         end
%     end
%     prob=sum(bsxfun(@times,w',g_ik),2);
% end


