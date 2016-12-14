clear;
close all;

I_max = 255;

% Choose the amount of faces to consider during the experiment among 90 images (15 people, 6 poses) :
chemin = 'faces';
numeros_individus = [1:4];
numeros_postures = [2,3,4];

% Number of n rows of X :
nb_individus = length(numeros_individus);
nb_postures = length(numeros_postures);
n = nb_individus*nb_postures;

% Number of columns p in X (Number of pixels in the images) :
fichier = [chemin '/i' num2str(numeros_individus(1),'%02d') num2str(numeros_postures(1),'%1d') '.mat'];
load(fichier);
img = eval(['i' num2str(numeros_individus(1),'%02d') num2str(numeros_postures(1),'%1d')]);
nb_lignes = size(img,1);
nb_colonnes = size(img,2);
p = nb_lignes*nb_colonnes;

% Create matrix X :
X = [];
for j = 1:nb_individus,
	for k = 1:nb_postures,
		fichier = [chemin '/i' num2str(numeros_individus(j),'%02d') num2str(numeros_postures(k),'%1d') '.mat'];
		load(fichier);
		img = eval(['i' num2str(numeros_individus(j),'%02d') num2str(numeros_postures(k),'%1d')]);
		if (size(img,1) ~= nb_lignes) || (size(img,2) ~= nb_colonnes)
			disp('Problem : All the images is not of the same size !');
			exit;
		end
		X = [X; double(img(:))'/I_max];
	end
end

% Plot the images of X :
figure('Name','Dataset of faces','Position',[0,0,550,500]);
colormap(gray(256)); 
for l = 1:n,
	j = numeros_individus(floor((l-1)/nb_postures)+1);
	k = numeros_postures(mod((l-1),nb_postures)+1);
	img = reshape(X(l,:),nb_lignes,nb_colonnes);
	subplot(nb_individus,nb_postures,l);
	imagesc(img);
	hold on;
	axis image;
	axis off;
	title(['Subject ' num2str(j,'%2d') ', pose ' num2str(k,'%1d')]);
end

% Calculation of the mean person :
average_face = mean(X);

% Calculation of the matrix X_average (=X-mean), which has the same size as X, each line contain the mean person :
[n,m]=size(X);
X_average = eye(n,m);
for i=1:n
    X_average(i,:)=average_face;
end

% Centering of the data : 
X_centre = X-X_average;

% Calculation of the variance/covariance matrix (impossible to calculate this way because of the size) :
%Sigma = transpose(X_centre)*(X_centre)/n;

% Calculation of the matrix Sigma_2 (matrices are smaller than sigma !) :
Sigma_2 =(X-X_average)*(X-X_average)'/n;

% Calculation of the eigen values/vectors of matrix Sigma_2 (each column of V_2 contains a eigen vector of Sigma_2) :
[V_2,D] = eig(Sigma_2);

% Calculation of eigen vector of Sigma (which are eigenfaces) deducted of those of Sigma_2 :
V = (X-X_average)'*V_2;

% Sort by croissant order of the eigen values of Sigma_2 :
D=diag(D);
[lambda,indices] = sort(D);

% Sort of eigenfaces in the same order as the eigenvalues :
[p,q]=size(V);
W=eye(p,q);

for i=1:q
    W(:,i)=V(:,indices(q-i+1));
end
[p,q]=size(W);

% remove the last eigenface, which belongs to the Sigma's kernel :
W = W(1:p,1:q-1);


% Normalisation of eigenfaces :
normes_eigenfaces = ones(size(W,1),1)*sqrt(sum(W.^2));
W=W./normes_eigenfaces;

% Matrix of the q first eigenfaces (you can change the value of q) :
[p,m]=size(W);
q = 8;
Wq = W(:,1:q);

% Label the training-poses

y_train=X_centre([1,2,4,5,7,8,10,11],:)*Wq;
class=[];
for i=1:size(y_train,1)
    class=[class;y_train(i,:)];
end

p1=class(1:2,:);
p2=class(3:4,:);
p3=class(5:6,:);
p4=class(7:8,:);

train=[p1;p2;p3;p4];

% Derive the test-set

y_test=X_centre([3,6,9,12],:)*Wq;
test=[];
for i=1:size(y_test,1)
    test=[test;y_test(i,:)];
end

% We know that test(j,:) corresponds to person pj

% Calculate Euclidean Distance, k-NN

% test1=test(1,:);
% test2=test(2,:);
% test3=test(3,:);
% test4=test(4,:);

% Allocate memory

% d1=zeros(size(train));
% d2=zeros(size(train));
% d3=zeros(size(train));
% d4=zeros(size(train));

% Choose k in k-NN, choose an odd number

k=7; % k can't be larger than the length of the feature-vector, which is 8 for 4 faces/persons

% for i=1:size(test,2)
%     for j=1:(size(train,1)*size(train,2))
%         d1(j)=sqrt((test1(i)-train(j))*(test1(i)-train(j))');
%     end
% end
true=zeros(length(numeros_individus),1);
false=zeros(length(numeros_individus),1);
d=zeros(size(test));
for i=1:size(test,1)
    for j=1:size(train,1)
        d(i,:)=sqrt((test(i,:)-train(j,:))*(test(i,:)-train(j,:))');
    end
    nn1=sort(d(i,:));
    nn1_idx=[];
    for p=1:k
        nn1_idx=[nn1_idx find(nn1(p)==d(i,:))'];
        if length(nn1_idx)>=k
            nn1_idx=nn1_idx(1:k);
            break
        end
    end
    score1=[];
    for m=1:length(nn1_idx)
        score1=[score1 sum(any(train(i,nn1_idx(m))==p1))];
    end
    score2=[];
    for m=1:length(nn1_idx)
        score2=[score2 sum(any(train(i,nn1_idx(m))==p2))];
    end
    score3=[];
    for m=1:length(nn1_idx)
        score3=[score3 sum(any(train(i,nn1_idx(m))==p3))];
    end
    score4=[];
    for m=1:length(nn1_idx)
        score4=[score4 sum(any(train(i,nn1_idx(m))==p4))];
    end

    score1=sum(score1);
    score2=sum(score2);
    score3=sum(score3);
    score4=sum(score4);
    
    if score1>[score2,score3,score4]
        if i==1
            true(i)=1;
        elseif i~=1
            false(i)=1;
        end
        disp(['Test' num2str(i) ' correspond to Person1'])
    elseif score2>[score1,score3,score4]
        if i==2
            true(i)=1;
        elseif i~=2
            false(i)=1;
        end
        disp(['Test' num2str(i) ' correspond to Person2'])
    elseif score3>[score2,score1,score4]
        if i==3
            true(i)=1;
        elseif i~=3
            false(i)=1;
        end
        disp(['Test' num2str(i) ' correspond to Person3'])
    elseif score4>[score2,score3,score1]
        if i==4
            true(i)=1;
        elseif i~=4
            false(i)=1;
        end
        disp(['Test' num2str(i) ' correspond to Person4'])
    end
end

figure
bar([sum(false),sum(true)])
Labels = {'Incorrect Classified','Correct Classified'};
set(gca, 'XTick', 1:2, 'XTickLabel', Labels);
title('Classifier Performance')

% nn1=sort(d1(:));
% nn1_idx=[];
% for p=1:k
%     nn1_idx=[nn1_idx find(nn1(p)==d1)'];
%     if length(nn1_idx)>=k
%         nn1_idx=nn1_idx(1:k);
%         break
%     end
% end

% Score is a measure that says which person-data that hat most hits from
% k-NN

% score1=[];
% for i=1:length(nn1_idx)
%     score1=[score1 sum(any(train(nn1_idx(i))==p1))];
% end
% score2=[];
% for i=1:length(nn1_idx)
%     score2=[score2 sum(any(train(nn1_idx(i))==p2))];
% end
% score3=[];
% for i=1:length(nn1_idx)
%     score3=[score3 sum(any(train(nn1_idx(i))==p3))];
% end
% score4=[];
% for i=1:length(nn1_idx)
%     score4=[score4 sum(any(train(nn1_idx(i))==p4))];
% end
% 
% score1=sum(score1);
% score2=sum(score2);
% score3=sum(score3);
% score4=sum(score4);
% 
% if score1>[score2,score3,score4]
%     disp('test1 correspond to person 1')
% elseif score2>[score1,score3,score4]
%     disp('test1 correspond to person 2')
% elseif score3>[score2,score1,score4]
%     disp('test1 correspond to person 3')
% elseif score4>[score2,score3,score1]
%     disp('test1 correspond to person 4')
% end

% if any(sum(sort(train(nn1_idx))==sort(p1(nn1_idx)))>[sum(sort(train(nn1_idx))==sort(p2(nn1_idx))),sum(sort(train(nn1_idx))==sort(p3(nn1_idx))),sum(sort(train(nn1_idx))==sort(p4(nn1_idx)))])
%     disp('test1 correspond to person 1')
% elseif any(sum(sort(train(nn1_idx))==sort(p2(nn1_idx)))>[sum(sort(train(nn1_idx))==sort(p1(nn1_idx))),sum(sort(train(nn1_idx))==sort(p3(nn1_idx))),sum(sort(train(nn1_idx))==sort(p4(nn1_idx)))])
%     disp('test1 correspond to person 2')
% elseif any(sum(sort(train(nn1_idx))==sort(p3(nn1_idx)))>[sum(sort(train(nn1_idx))==sort(p1(nn1_idx))),sum(sort(train(nn1_idx))==sort(p1(nn1_idx))),sum(sort(train(nn1_idx))==sort(p4(nn1_idx)))])
%     disp('test1 correspond to person 3')
% elseif any(sum(sort(train(nn1_idx))==sort(p4(nn1_idx)))>[sum(sort(train(nn1_idx))==sort(p1(nn1_idx))),sum(sort(train(nn1_idx))==sort(p3(nn1_idx))),sum(sort(train(nn1_idx))==sort(p1(nn1_idx)))])
%     disp('test1 correspond to person 4')
% end

% figure
% for i=1:size(class,1)
%     plot(class(i,:),'bo')
%     hold on
% end
% hold off










