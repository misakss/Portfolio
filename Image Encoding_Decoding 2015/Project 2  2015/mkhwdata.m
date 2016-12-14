function z = mkhwdata(pnr)

%
% z = mkhwdata(pnr)
%	
% 	z	- Signal, containing the information
%	
%	pnr	- Personnummer. If you are two, use mkhwdata([pnr1;pnr2])
%	
%
%  mkhwdata:
%     Generate data for Homework III, Fall 2011
%     
%     Mats Bengtsson, 5/3 2011
%     Mats Bengtsson, 23/11 2011
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% VT2013 version

load hwdata;

pnr = pnr(:);
pnr = round(mean(pnr));


% Extract the pictures
c = magic(256*3);
cv = c(:);
I = reshape(hwdata(cv),[256,256,9]);

tmp=pnr;
S1nummer=mod(tmp,8);
tmp=floor(tmp/8);
S2nummer=mod(tmp,7);
tmp=floor(tmp/7);
S3nummer=mod(tmp,6);

S1img = I(:,:,S1nummer+1);
I=I(:,:,[1:S1nummer,S1nummer+2:end]);
S2img = I(:,:,S2nummer+1);
I=I(:,:,[1:S2nummer,S2nummer+2:end]);
S3img = I(:,:,S3nummer+1);


S1vec = imvec(S1img);
S2vec = imvec(S2img);
S3vec = imvec(S3img);

Nsig = length(S1vec); % Number of samples

SigRatio_dB = [-20,0,-10];
SigRatio=10.^(SigRatio_dB/20);

z = SigRatio(1)*S1vec/norm(S1vec)+...
    SigRatio(2)*(-1).^[0:Nsig-1]'.*S2vec/norm(S2vec)+...
    SigRatio(3)*cos(pi/2*[0:Nsig-1]').*S3vec/norm(S3vec);



%
%     [c]=imvec(A)
%
%     "Code" an image A onto a vector c.
%
%     Tomas Andersson, 12/1 2001
%     Heavily modified Mats Bengtsson, 5/3 2011
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [c]=imvec(A)

a = double(A(:)) - mean(A(:));
c = interp(a,4,4,.45);


