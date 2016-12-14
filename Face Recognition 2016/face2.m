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
load face1;


% Matrix of the q first eigenfaces (you can change the value of q) :
[p,m]=size(W);
q = 8;
Wq = W(:,1:q);

size(Wq);
size(X_centre);
% Calculate of the principal component of the n images of database on this eigenfaces family :
composantes_principales_ensemble_apprentissage = X_centre*Wq;
cpea=composantes_principales_ensemble_apprentissage;
size(cpea);

% Reconstruction based on these q principal component :
X_reconstruit = X_average + cpea*Wq';

% Draw of the n restructured images :
figure('Name','Good codifications','Position',[0,0,550,500]);
colormap(gray(256));
for k = 1:n
	img = reshape(X_reconstruit(k,:),nb_lignes,nb_colonnes);
	subplot(nb_individus,nb_postures,k);
	imagesc(img);
	hold on;
	axis image;
	axis off;
	title(['Decoded image ',num2str(k)]);
end

% Calculation of the RMSE between original and restructured images :
RMSE = [];
valeurs_q = [];
for q = 1:n-1
	Wq = W(:,1:q);
	composantes_principales_ensemble_apprentissage = X_centre*Wq ; 
	X_reconstruit = X_average + composantes_principales_ensemble_apprentissage*Wq';
	ecart_quadratique_average = norm(X_reconstruit-X);
	RMSE = [RMSE;sqrt(ecart_quadratique_average)];
	valeurs_q = [valeurs_q;q];
end

disp('values of (q , RMSE)');
[valeurs_q,RMSE]

% Draw of the RMSE graphdepending on number q of components :
figure('Name','RMSE vs q (# eigenfaces)','Position',[550,0,550,500]);
plot(valeurs_q(:,1),RMSE(:,1),'r+');
hx = xlabel('$q$','FontSize',20);
set(hx,'Interpreter','Latex');
hy = ylabel('RMSE','FontSize',20);
set(hy,'Interpreter','Latex');

% Reading of the first image of the database :
fichier = [chemin '/i' num2str(numeros_individus(1),'%02d') num2str(numeros_postures(1),'%1d') '.mat'];
load(fichier);
img = eval(['i' num2str(numeros_individus(1),'%02d') num2str(numeros_postures(1),'%1d')]);

% Rotation of this image of Pi :
for i = 1:nb_lignes
	for j = 1:nb_colonnes
		image_tournee(i,j) = img(nb_lignes-i+1,nb_colonnes-j+1);
	end
end

% Calculation of the principal component of the rotationed image:
image_tournee_dessin=image_tournee;
image_tournee=double(image_tournee(:))/255;
image_tournee=image_tournee';
taille_image = size(image_tournee);
taille_W = size(W);
composantes_principales_image_tournee = (image_tournee-average_face)*(W);

% Reconstruction of the rotationed image with its n-1 principal components :
image_tournee_reconstruite = average_face + composantes_principales_image_tournee*W';

% Draw of the rotationed image and of the restructured image
figure('Name','Bad codifications','Position',[1100,0,550,500]);
colormap(gray(256));
subplot(2,2,1);
imagesc(image_tournee_dessin);
hold on;
axis image;
axis off;
title('Original flipped face');
image_tournee_reconstruite = reshape(image_tournee_reconstruite,nb_lignes,nb_colonnes);
subplot(2,2,2);
imagesc(image_tournee_reconstruite);
hold on;
axis image;
title('Decoded flipped face');

% Read of the image of a person which don't belongs to the database
if (nb_individus<15)
	numeros_individus_tries = sort(numeros_individus);
	indice = 1;
	while (indice<=nb_individus && indice==numeros_individus_tries(indice))
		indice = indice+1;
	end
	indice_individu_hors_apprentissage = indice;

	fichier = [chemin '/i' num2str(indice_individu_hors_apprentissage,'%02d') num2str(numeros_postures(1),'%1d') '.mat'];
	load(fichier);
	img = eval(['i' num2str(indice_individu_hors_apprentissage,'%02d') num2str(numeros_postures(1),'%1d')]);

	% Calculation of the principal component :
    img2=double(img(:))'/255;
	composantes_principales = (img2-average_face)*W;

	%  Reconstruction of the image with its n-1 principal components :
	image_reconstruite = average_face + composantes_principales*W';

	% Draw of the image and restructured image :
	subplot(2,2,3);
	imagesc(img);
	hold on;
	axis image;
	axis off;
	title('Original external face');
	image_reconstruite = reshape(image_reconstruite,nb_lignes,nb_colonnes);
	subplot(2,2,4);
	imagesc(image_reconstruite);
	hold on;
	axis image;
	title('Decoded external face');
end
