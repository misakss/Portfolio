close all
clear
load data;

%column 1 : height
%column 2 : weight
%column 3 : 0 for boy, 1 for girl


%%%%%%%%%%% Cross-Validation, split dataset 5 times

N=size(data,1);
far_tmp=[];
frr_tmp=[];
empty=0;
rS=0;
while rS<5
    N_split=randi(N,1,1);
    rS=rS+1;

    data_train=data(1:N_split,:);
    data_test=data(N_split+1:N,:);

    %%%%%%%%%%%%%%%%%%%%% TRAINING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [a,b]=lms_train(data_train, empty);
    if a==1.0005 & b==1.0005
        rS=rS-1;
        continue
    end
    %%%%%%%%%%%%%%%%%%%%% VALIDATION PART %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [m,n]=lms_validation(data_test, a, b, empty);
    far_tmp=[far_tmp m];
    frr_tmp=[frr_tmp n];
end

far=sum(far_tmp)/5;
frr=sum(frr_tmp)/5;

% Display on the Matlab command line
disp(['FAR = ' num2str(far,'%.2f') ' (False Girls Rate)']);
disp(['FRR = ' num2str(frr,'%.2f') ' (False Boys Rate)']);

