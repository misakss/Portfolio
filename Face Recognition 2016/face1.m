% This source code has been distributed for teaching purposes only
%
% Author: Jean-Denis Durou (Jean-Denis.Durou@irit.fr)
% 
% Modified by: Xavier Giro-i-Nieto (xavier.giro@upc.edu)
%
% All rights reserved - 2013
%

clear;
close all;
load faces;
%This file contain the database.

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

% Draw of the mean person and the eigenfaces :
figure('Name','Eigenfaces','Position',[550,0,550,500]);
colormap(gray(256));
img = reshape(average_face,nb_lignes,nb_colonnes);
subplot(nb_individus,nb_postures,1);
imagesc(img);
hold on;
axis image;
axis off;
title(['Average face']);
for k = 1:n-1
	img = reshape(W(:,k),nb_lignes,nb_colonnes);
	subplot(nb_individus,nb_postures,k+1);
	imagesc(img);
	hold on;
	axis image;
	axis off;
	title(['Eigenface ',num2str(k)]);
end

save face1;
