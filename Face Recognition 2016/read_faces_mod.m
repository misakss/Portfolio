clear;
close all;

I_max = 255;

% Choose the amount of faces to consider during the experiment among 90 images (15 people, 6 poses) :
chemin = 'faces';
numeros_individus = [3:10];
numeros_postures = [2,3,4,5,6];

% Nombre de lignes n de X (nombre d'images d'apprentissage) :
nb_individus = length(numeros_individus);
nb_postures = length(numeros_postures);
n = nb_individus*nb_postures;

% Nombre de colonnes p de X (nombre de pixels des images) :
fichier = [chemin '/i' num2str(numeros_individus(1),'%02d') num2str(numeros_postures(1),'%1d') '.mat'];
load(fichier);
img = eval(['i' num2str(numeros_individus(1),'%02d') num2str(numeros_postures(1),'%1d')]);
nb_lignes = size(img,1);
nb_colonnes = size(img,2);
p = nb_lignes*nb_colonnes;

% Remplissage de la matrice X :
X = [];
for j = 1:nb_individus,
	for k = 1:nb_postures,
		fichier = [chemin '/i' num2str(numeros_individus(j),'%02d') num2str(numeros_postures(k),'%1d') '.mat'];
		load(fichier);
		img = eval(['i' num2str(numeros_individus(j),'%02d') num2str(numeros_postures(k),'%1d')]);
		if (size(img,1) ~= nb_lignes) || (size(img,2) ~= nb_colonnes)
			disp('Probleme : les images ne sont pas toutes de meme taille !');
			exit;
		end
		X = [X; double(img(:))'/I_max];
	end
end

% Affichage sous forme de planche-contact (un individu par ligne, une posture par colonne) :
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

save faces;
