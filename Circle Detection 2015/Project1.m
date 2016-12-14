close all
clear all

% Step 1

tic
i=imread('test10.jpg');
j=imread('test22.jpg');
k=imread('test19.jpg');
subplot(1,3,1)
imshow(i)
title('Picture 1')
subplot(1,3,2)
imshow(j)
title('Picture 2')
subplot(1,3,3)
imshow(k)
title('Picture 3')

input_val=input('\n Which one of the pictures 1, 2 and 3 would you like to use?: ');

if input_val~=1 && input_val~=2 && input_val~=3
    disp('Error: You have to choose 1, 2 or 3')
    input_val=input('\n Simply write 1, 2 or 3: ');
end

if input_val==1
    input_val=i;
elseif input_val==2
    input_val=j;
elseif input_val==3
    input_val=k;
end

im=input_val;
i=im;

% 0.2989*R+0.5870*G+0.1140*B can be done in two ways

% Either like this, with MATLABs function im2double:
% % a=im2double(i);
% % I=0.2989*a(:,:,1) + 0.5870*a(:,:,2) + 0.1140*a(:,:,3);

% Or like this, calculating without any specific MATLAB function:
for k=1:size(i,1)
    for l=1:size(i,2)
        % I(k,l)=m*n;
        I(k,l)=(0.2989*i(k,l,1))+(0.587*i(k,l,2))+(0.114*i(k,l,3));
    end
end

% Step 2

X = sprintf('\n Convolution has started...');
disp(X)

F1=[-1 0 1;-2 0 2;-1 0 1];
F2=[-1 -2 -1;0 0 0;1 2 1];

% Convolve I with F1 and F2
Gx=zeros(size(I));
Gy=zeros(size(I));

for i=2:size(I,1)-1
    for j=2:size(I,2)-1
        Gx(i,j)=sum(sum(double(I(i-1:i+1,j-1:j+1)).*F1));
        Gy(i,j)=sum(sum(double(I(i-1:i+1,j-1:j+1)).*F2));
    end
end

X = sprintf('\n Convolution is done');
disp(X)

G=sqrt(Gx.^2+Gy.^2);

% One method to get the binary picture
% for i=1:size(G,1)
%     for j=1:size(G,2)
%         if G(i,j)>=max(G(:))*0.35
%             G(i,j)=1;
%         else
%             G(i,j)=0;
%         end
%     end
% end

% A faster method to get the binary picture
I=G>=0.3*max(G(:));

% Step 3

X = sprintf('\n Hough transform has started...');
disp(X)

A=zeros(size(I,1),size(I,2),75);
[x,y]=find(I==1);
n=0.12; 

for a=min(x):max(x)
    for b=min(y):max(y)
        for c=35:1:70
            check=find(abs(sqrt((x-a).^2+(y-b).^2)-c)<=n);
            if ~isempty(check)
                A(a,b,c)=A(a,b,c)+length(check);
            end
        end
    end
end
    
X = sprintf('\n Hough transform is done');
disp(X)

m=0.5; 
filter=A>max(max(max((A))))*m; 
Amax=imregionalmax(A.*filter);
X = sprintf('\n Now circles will be drawn...');
disp(X)
[xmax,ymax,cmax]=ind2sub(size(Amax),find(Amax)); % Need this with 3D

for i=2:length(xmax)
    dist=sqrt((xmax(i)-xmax(i-1)).^2+(ymax(i)-ymax(i-1)).^2);
    if dist>cmax(i)
        for alpha=0:0.01:2*pi
            circ_x=round(xmax(i)+cmax(i)*cos(alpha));
            circ_y=round(ymax(i)+cmax(i)*sin(alpha));
            im(circ_x,circ_y,2)=255;
            im(circ_x,circ_y,[1 3])=0;
        end
    end
end

for alpha=0:0.01:2*pi
    circ_x=round(xmax(1)+cmax(1)*cos(alpha));
    circ_y=round(ymax(1)+cmax(1)*sin(alpha));
    im(circ_x,circ_y,2)=255;
    im(circ_x,circ_y,[1 3])=0;
end

X = sprintf('\n Drawing circles is done');
disp(X)
figure
imshow(im)
c=toc;
X = sprintf('\n The program is done, it took %f seconds to run the program',c);
disp(X)













