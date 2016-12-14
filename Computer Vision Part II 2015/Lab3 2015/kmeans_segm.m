function [segmentation,centers]=kmeans_segm(image,K,L,seed)
    if nargin>3
        rng(seed);
    end
    if ndims(image)==3
        Ivec=single(reshape(image,size(image,1)*size(image,2),3));
    else
        Ivec=image;
    end
    centers=Ivec(round(rand(K,1)*(size(Ivec,1)-1))+1,:);
    dist=pdist2(Ivec,centers);
    for i=1:L
        [~,clusterMask]=min(dist,[],2);     %The clusters are represented in the columns, so we min in each row
        for j=1:K
            centers(j,:)=mean(Ivec(clusterMask==j,:),1);
        end
        dist=pdist2(Ivec,centers);
    end
    if ndims(image)==3
        segmentation=reshape(clusterMask,size(image,1),size(image,2));
    else
        segmentation=clusterMask;
    end
end

% function [segmentation,centers]=kmeans_segm(image,K,L,seed)
%     rng(seed);
%     image=double(image);
%     Ivec=double(reshape(image,size(image,1)*size(image,2),3));
%     posrand=round(rand(K,1)*(size(image,1)*size(image,2)-1))+1;
%     centers=[Ivec(posrand,1),Ivec(posrand,2),Ivec(posrand,3)];
% %     centers=[round(rand(K,1)*255),round(rand(K,1)*255),round(rand(K,1)*255)];
% %     Ivec=reshape(image,size(image,1)*size(image,2),3);
%     dist=pdist2(Ivec,centers);
%     for i=1:L
%         [~,clusterMask]=min(dist,[],2);     %The clusters are represented in the columns, so we min in each row
%         for j=1:K
%             centers(j,:)=mean(Ivec(clusterMask==j,:),1);
%         end
%         dist=pdist2(Ivec,centers);
%     end
%     segmentation=reshape(clusterMask,size(image,1),size(image,2));
% end