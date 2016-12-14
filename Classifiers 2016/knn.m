close all
clear all
clc

load data

N=size(data,1);
N_train = round(N/2);

% lms2.m
% data_train = data(1:N_train,:);
% data_test = data(N_train+1:N,:);

% lms3.m
data_train = data(N_train+1:N,:);
data_test = data(1:N_train,:);

% Assign each validation-sample the same lable as the k nearest
% training-samples

true_boys=0;
true_girls=0;
false_boys=0;
false_girls=0;
boys=[];
girls=[];
d=zeros(size(data_test,1),1);
% Choose k odd since it is a 2-class problem
k=3;
for i=1:size(data_test,1)
    for j=1:size(data_train,1)
        d(j)=sqrt((data_test(i,1:2)-data_train(j,1:2))*(data_test(i,1:2)-data_train(j,1:2))');
    end
    nn=sort(d);
    nn_idx=[];
    for p=1:k
        nn_idx=[nn_idx find(nn(p)==d)'];
        if length(nn_idx)>=k
            nn_idx=nn_idx(1:k);
            break
        end
    end
    if mode(data_train(nn_idx,3))==0
        boys=[boys; data_test(i,1:2)];
    elseif mode(data_train(nn_idx,3))==1
        girls=[girls; data_test(i,1:2)];
    end
end            

plot(boys(:,1),boys(:,2),'rx')
hold on
plot(girls(:,1),girls(:,2),'bo')
title(['k (', num2str(k), ') Nearest Neighbor'],'Interpreter','Latex','FontSize',15);
hx = xlabel('$height$','FontSize',15);
set(hx,'Interpreter','Latex');
hy = ylabel('$weight$','FontSize',15);
set(hy,'Interpreter','Latex');
axis([150 200 50 110 ]);

knn_boys_idx=[];
for v=1:size(boys,1)
    knn_boys_idx=[knn_boys_idx find(boys(v)==data_test(:,1:2))'];
end

for i=1:length(knn_boys_idx)
% If the estimated class is boy 
    % ...and it is actually a boy
    if data_test(knn_boys_idx(i),3)==0
        true_boys=true_boys+1;
    % ...but it is not a boy
    elseif data_test(knn_boys_idx(i),3)==1
        false_boys=false_boys+1;
    end
end

knn_girls_idx=[];
for v=1:size(girls,1)
    knn_girls_idx=[knn_girls_idx find(girls(v)==data_test(:,1:2))'];
end

for j=1:length(knn_girls_idx)
% If the estimated class is girl...
    % ...and it is actually a girl
    if data_test(knn_girls_idx(j),3)==1
        true_girls=true_girls+1;
    % ...but it is not a girl
    elseif data_test(knn_girls_idx(j),3)==0
        false_girls=false_girls+1;
    end
end

% Computation of False Acceptance Rate (FAR) and False Rejection Rate (FRR)
total_girls = true_girls + false_girls;
if total_girls > 0
    far = false_girls/total_girls;
else
    far = 0;
end

total_boys = true_boys + false_boys;
if total_boys > 0
    frr = false_boys/total_boys;
else
    frr = 0;
end

% Display on the Matlab command line
disp(['FAR = ' num2str(far,'%.2f') ' (False Girls Rate)']);
disp(['FRR = ' num2str(frr,'%.2f') ' (False Boys Rate)']);

figure
stem(frr,far)
title(['FRR and FAR for k = ', num2str(k), ', k Nearest Neighbor'],'Interpreter','Latex','FontSize',15);
hx = xlabel('$FRR$','FontSize',15);
set(hx,'Interpreter','Latex');
hy = ylabel('$FAR$','FontSize',15);
set(hy,'Interpreter','Latex');

