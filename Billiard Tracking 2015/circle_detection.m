function [xmax,ymax] = circle_detection(im,r)
%A function that finds and marks circles in an image im.
%
%[xmax,ymax,rmax]=coin_detection(im)
%where (xmax,ymax) is the positions of the center and rmax is the radius of
%the circles. im is a string which represents the image.
    %image=imread(im);
    image=im;
    o_img=image;

    I=0.2989*image(:,:,1) + 0.5870*image(:,:,2) + 0.1140*image(:,:,3);

    F1=[-1 0 1;-2 0 2;-1 0 1];
    F2=[-1 -2 -1;0 0 0;1 2 1];

    Gx=zeros(size(I));
    Gy=zeros(size(I));
   
    for i=1:size(F1,1)
        for j=1:size(F1,2)
            %Moving the image one step in each direction instead of moving
            %the filters through the entire image
            Gx(2:end-1,2:end-1)=bsxfun(@plus,Gx(2:end-1,2:end-1),double(I(i:(end-(size(F1,1)-i)),j:(end-(size(F1,1)-j)))).*F1(i,j));
            Gy(2:end-1,2:end-1)=bsxfun(@plus,Gy(2:end-1,2:end-1),double(I(i:(end-(size(F2,1)-i)),j:(end-(size(F2,1)-j)))).*F2(i,j));
        end
    end

    G=sqrt(Gx.^2+Gy.^2);
    
    I=G>=0.03*max(max(G));
    
    radius=r;   %lowest value in the test images to the highest one
    A=zeros(size(I,1),size(I,2),max(radius),'uint32');  %uint32 is way faster than double when dealing with basic operations
    [x_list,y_list]=find(I);      %x,a=rows, y,b=columns

    %predefined circles
    a=[];b=[];r=[]; %should prealocate, but this loop barely takes any time
    for rad=radius
        %generate the circles by using a matrix inequallity function instead if
        %not too slow, current does not produce a round circle cause forced
        %rows.
        rows=-rad:rad;
        a=[a rows rows(2:end-1)];    %lines represents all a we will look through for every (x,y) coord
        colLeft=-round(sqrt(rad^2-rows.^2));
        colRight=round(sqrt(rad^2-rows.^2));
        b=[b colLeft colRight(2:end-1)];
        r=[r rad*ones(length(rows)*2-2,1)'];
    end

    circleIndexes=a+(b-1)*size(A,1)+(r-1)*size(A,1)*size(A,2);  %A faster version of sub2ind, and makes it clearer as to what is happening.
                                                                %It is also needed since sub2ind doesn't take negative values.        
    xyIndexes=sub2ind(size(I),x_list,y_list);   %should use it here too, but it doesnt cost much speed

    for i=1:length(xyIndexes)
        tmp=uint32(xyIndexes(i)+circleIndexes+size(A,1));   %add size(A,1) since we get -2*size(A,1) from adding circleIndexes and xyIndexes
        checkLimits=bsxfun(@and,tmp>0,tmp<(size(A,1)*size(A,2)*size(A,3)));
        %remove the entire circle with that radius
        radremove=unique(r(checkLimits==0));
        for j=radremove
            checkLimits(r==j)=0;
        end
        tmp=tmp(all(checkLimits,1));
        A(tmp)=A(tmp)+1;
    end
    

    surf(A(:,:,9))
    filter=uint32(A>max(A(:))*0.7);    %sticking with uint32 for speed
    Amax=imregionalmax(A.*(filter));
    [xmax,ymax,cmax]=ind2sub(size(A),find(Amax));
    
    filter=ones(size(xmax));
    for i=1:length(xmax)
        for j=(i+1):length(xmax)
            if (xmax(i)-xmax(j))^2+(ymax(i)-ymax(j))^2<2*(cmax(i))^2;
                %remove the one with the least weight
                if A(xmax(i),ymax(i),cmax(i))<A(xmax(j),ymax(j),cmax(j))
                    filter(i)=0;
                else
                    filter(j)=0;
                end
            end
        end
    end
    xmax=xmax(all(filter,2));
    ymax=ymax(all(filter,2));
    cmax=cmax(all(filter,2));

%     [val,ind]=sort(A(:),'descend');       
%     [xmax,ymax,rmax]=ind2sub(size(A),ind(1:45));
    
    for i=1:length(xmax)
        for alpha=0:0.01:2*pi
            circ_x=round(xmax(i)+radius*cos(alpha));
            circ_y=round(ymax(i)+radius*sin(alpha));
            if circ_x<=0 || circ_y<=0
                continue;
            end
            o_img(circ_x,circ_y,2)=255;
            o_img(circ_x,circ_y,[1 3])=0;
        end
    end
%     subplot(1,2,1)
%     imshow(o_img)
%     subplot(1,2,2)
%     imshow(I)
%     drawnow
end