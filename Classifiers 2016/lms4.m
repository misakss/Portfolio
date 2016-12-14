close all
clear
load data;

%column 1 : height
%column 2 : weight
%column 3 : 0 for boy, 1 for girl


%%%%%%%%%%% Selection of 50% of the data to make the data Train :

N=size(data,1);
N_half=round(N/2);
randSet=randperm(N);
data_train=data(randSet(1:N_half),:);
data_test=data(randSet(N_half+1:N),:);

% This one takes forever, but I wanted to try without MATLAB's function
% vec=[];
% i=0;
% while i < N
%     i=i+1;
%     randData = randi(N,1,1);
%     vec=[vec randData];
%     test_or_train=round(rand(1,1,1));
%     if ~any(randData==vec)
%         if test_or_train==1
%             data_train(i,:) = data(randData,:);
%         elseif test_or_train==0
%             data_test(i,:) = data(randData,:);
%         end
%     elseif any(randData==vec)
%         i=i-1;
%     end
% end

%%%%%%%%%%%%%%%%%%%%% TRAINING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[a,b]=lms_train(data_train);


%%%%%%%%%%%%%%%%%%%%% VALIDATION PART %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[far,frr]=lms_validation(data_test, a, b );

% Display on the Matlab command line
disp(['FAR = ' num2str(far,'%.2f') ' (False Girls Rate)']);
disp(['FRR = ' num2str(frr,'%.2f') ' (False Boys Rate)']);
