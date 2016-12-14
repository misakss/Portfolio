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


% Reading of the first image in database
fichier = [chemin '/i' num2str(numeros_individus(1),'%02d') num2str(numeros_postures(1),'%1d') '.mat'];
load(fichier);
img = eval(['i' num2str(numeros_individus(1),'%02d') num2str(numeros_postures(1),'%1d')]);

% Set to 0 of pixels localised between the lines line_min and line_max (Incomplete face 1) :
line_min = 200;
line_max = 280;

% Allocate memory for speed
face_incomplete_1 = zeros( size(img) );

for i = 1:nb_lignes
	for j = 1:nb_colonnes
		face_incomplete_1(i,j) = img(i,j);
	end
end
for i = line_min:line_max
	face_incomplete_1(i,:) = 0;
end

% Calculation of principal components of image degradee 1 :
face_incomplete_1_dessin = face_incomplete_1;
face_incomplete_1=double(face_incomplete_1)/255;
face_incomplete_1=face_incomplete_1(:);
face_incomplete_1=face_incomplete_1';
size(face_incomplete_1)
size(average_face)
composantes_principales_face_incomplete = (face_incomplete_1-average_face)*W;

% Reconstruction of image degradee 1 with its n-1 principal components :
face_incomplete_reconstruite = average_face + composantes_principales_face_incomplete*W';

%Draw of image degradee 1 and restructured image degradee 1 :
figure('Name','Aplication to inpainting','Position',[0,0,550,500]);
colormap(gray(256));
subplot(2,2,1);
imagesc(face_incomplete_1_dessin);
hold on;
axis image;
axis off;
title('Incomplete face 1');
face_incomplete_reconstruite = reshape(face_incomplete_reconstruite,nb_lignes,nb_colonnes);
subplot(2,2,2);
imagesc(face_incomplete_reconstruite);
hold on;
axis image;
axis off;
title('Reconstruction of incomplete face 1');

% Allocate memory for speed
face_incomplete_2 = zeros( size(img) );

% Set to 0 of pixels outside lines line_min to line_max (image degradee 2) :
for i = 1:nb_lignes
	for j = 1:nb_colonnes
		face_incomplete_2(i,j) = img(i,j);
	end
end
for i = 1:line_min
    face_incomplete_2(i,:)=0;
end

% Calculation of principal components of image degradee 2 :
face_incomplete_2_dessin = face_incomplete_2;
face_incomplete_2=double(face_incomplete_2)/255;
face_incomplete_2=face_incomplete_2(:);
face_incomplete_2=face_incomplete_2';

composantes_principales_face_incomplete = (face_incomplete_2-average_face)*W;

% Reconstruction of image degradee 2 with its n-1 principal components :
face_incomplete_reconstruite = average_face + composantes_principales_face_incomplete*W';

%Draw of image degradee 1 and restructured image degradee 1 :
subplot(2,2,3);
imagesc(face_incomplete_2_dessin);
hold on;
axis image;
axis off;
title('Incomplete face 2');
face_incomplete_reconstruite = reshape(face_incomplete_reconstruite,nb_lignes,nb_colonnes);
subplot(2,2,4);
imagesc(face_incomplete_reconstruite);
hold on;
axis image;
axis off;
title('Reconstruction of incomplete face 2');
