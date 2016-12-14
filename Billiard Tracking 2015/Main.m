function [] = Main(vid, r, data, starttime, endtime, verbose)
    v=VideoReader(vid);
    if nargin>3
        frames=read(v, [starttime*v.FrameRate endtime*v.FrameRate]);
    else
        frames=read(v);
    end
    if nargin<4
        verbose=2;
    end
    
    v=VideoWriter('BilliardTracking.mp4');
    open(v)

    [S,R,Q,Lambda_psi]=init(size(frames,2),size(frames,1));
    cflag=0;
    err=zeros(1,size(frames,4)-1);

    %make an estimate of the number of clusters using a different method that works when they are STATIONARY?
    
    %Main loop
    for i=1:size(frames,4)
       
        
        %Get circles from the image
        image=frames(:,:,:,i);

        z=data{i};
        %K-means N clusters
        
        S_bar=predict(S,R,v);
%         imshow(image)
%         hold on
%         plot(S_bar(1,:),S_bar(2,:),'rx');
%         hold off
%         drawnow()

%         S_bar(1,S_bar(1,:)<0)=0;  %Removed since we remove clusters with
%         too large mean difference
%         S_bar(1,S_bar(1,:)>size(image,2))=size(image,2);
%         S_bar(2,S_bar(2,:)<0)=0;
%         S_bar(2,S_bar(2,:)>size(image,1))=size(image,1);
        [outlier,Psi] = associate(S_bar,z,Lambda_psi,Q);
        
        
        
        
        S_bar=weight(S_bar,Psi,outlier);
        
        
        
        %Stratified resampling?
        
        %Displaying code around (x,y):
        for alpha=0:0.01:2*pi
            %make the line 3 thick
            for m=-1:1
%                 circ_x=round(mean(S_bar(2,:))+r*cos(alpha));
%                 circ_y=round(mean(S_bar(1,:))+r*sin(alpha));
% %                 plot(circ_y,circ_x,'gx');
%                 image(circ_x,circ_y,2)=255;
%                 image(circ_x,circ_y,[1 3])=0;
                for j=1:size(z,2)
                    circ_x=round(z(2,j)+r*cos(alpha));
                    circ_y=round(z(1,j)+r*sin(alpha));
%                     plot(circ_y,circ_x,'rx');
                    image(circ_x,circ_y,1)=255;
                    image(circ_x,circ_y,[2 3])=0;
                end
            end
        end
        
        if verbose>1
            imshow(image)
            hold on
        end
        S=[];
        if(cflag)
%             nrclusters=10;
%             startpos=round(rand(1,nrclusters)*(size(z,2)-1)+1);

            [indx, C, ~,D]=kmeans(S_bar(1:2,:)',size(z,2),'Distance','sqeuclidean','Start',z');
            
            
%             [C,MSindx]=MeanShiftCluster(C',100);
%             max(MSindx)
%             max(indx)
%             '---'
%             for j=1:size(MSindx,2)
%                 indx(indx==j)=MSindx(j);
%             end
% %             C=C';
%             indx=clusterdata(S_bar(1:2,:)',8);    %Can't use Hierichal clustering, merges as
%             soon as too close and will always be cause R

            meanD=zeros(1,max(indx));
            cutoff=20;
            for j=1:max(indx)
                meanD(j)=mean(D(indx==j,j));
            end
            
            for j=find(meanD>cutoff*min(meanD)) %Can cause problems if max index is 1?
                tmp=meanD(meanD<=cutoff*min(meanD));
                [~,A]=min(abs(tmp-meanD(j)));
                indx(indx==j)=find(meanD==tmp(A));
                disp(['mergin cluster ',num2str(j),' with cluster ',num2str(find(meanD==tmp(A)))])
            end
            
            cmap=hsv(max(indx));
            for j=1:max(indx)                
%                 disp([num2str(j),' : ',num2str(size(find(indx==j),1)),' : ',num2str(mean(D(indx==j,j)))])
                if ~isempty(S_bar(:,indx==j))
                    tmp=stratified_resample(S_bar(:,indx==j));
                    S=[S tmp]; 
                    if verbose>1
                        plot(tmp(1,:),tmp(2,:),'x','Color',cmap(j,:));
                        plot(C(j,1),C(j,2),'o','Color',cmap(j,:));
                    end
                end
            end
            [~, C]=kmeans(S(1:2,:)',size(z,2),'Distance','sqeuclidean','Start',z');
            closest=[];

            for k=1:size(z',1)
                tmp=bsxfun(@minus,C,z(:,k)');
                tmp=sqrt(tmp(:,1).^2+tmp(:,2).^2);
                closest=[closest min(tmp)];
            end
%             for k=1:size(C,1)
%                 tmp=bsxfun(@minus,C(k,:),z');
%                 tmp=sqrt(tmp(:,1).^2+tmp(:,2).^2);
%                 closest=[closest min(tmp)];
%             end
            err(i-1)=mean(closest);
        else
           S=stratified_resample(S_bar);
           cflag=1;
        end
        if verbose>1
            hold off
            drawnow
        end
        
%         pause()
       writeVideo(v,getframe(gcf));
    end
    close(v);
    err
    mean(err)
    max(err)
end