% script least mean square classifier with half data as train data and half
% as test data version 1
%Gives the FAR and the FRR

% Copyright ©  2013  Lesley-Ann DUFLOT and Xavier Giro-i-Nieto
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.



close all
clear
load data;

%column 1 : height
%column 2 : weight
%column 3 : 0 for boy, 1 for girl


%%%%%%%%%%% Selection of 50% of the data to make the data Train :

N=size(data,1);
N_test = round(N/2);

data_train = data(N_test+1:N,:);
data_test = data(1:N_test,:);

%%%%%%%%%%%%%%%%%%%%% TRAINING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[a,b]=lms_train(data_train);


%%%%%%%%%%%%%%%%%%%%% VALIDATION PART %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[far,frr]=lms_validation(data_test, a, b );

% Display on the Matlab command line
disp(['FAR = ' num2str(far,'%.2f') ' (False Girls Rate)']);
disp(['FRR = ' num2str(frr,'%.2f') ' (False Boys Rate)']);
