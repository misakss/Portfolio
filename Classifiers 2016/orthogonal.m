close all
clear
load data;

%column 1 : height
%column 2 : weight
%column 3 : 0 for boy, 1 for girl

boy_idx=find(data(:,3)==0);
girl_idx=find(data(:,3)==1);

boys_height=data(boy_idx,1);
boys_weight=data(boy_idx,2);
girls_height=data(girl_idx,1);
girls_weight=data(girl_idx,2);

av_boys_h=mean(boys_height);
av_boys_w=mean(boys_weight);
av_girls_h=mean(girls_height);
av_girls_w=mean(girls_weight);

N=size(data,1);
N_train = round(N/2);

% lms2.m
% data_train = data(1:N_train,:);
% data_test = data(N_train+1:N,:);

% lms3.m
data_train = data(N_train+1:N,:);
data_test = data(1:N_train,:);

%%%%%%%%%%%%%%%%%%%%% TRAINING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define two arrays to store the data for boys and girls
[boys, girls] = build_datasets(data);

% Estimate the a and b paramteres of the LMS classifier, where =ax+b

% y=kx+m for the blue dashed line. The orthogonal line is written
% y=ax+b. k*a=-1
k=(av_boys_w-av_girls_w)/(av_boys_h-av_girls_h);
y=av_girls_w+(av_boys_w-av_girls_w)/2; % the middle of the dashed line
x=av_girls_h+(av_boys_h-av_girls_h)/2; % the middle of the dashed line
aa=-1/k;
bb=y-aa*x;

% The following method doesn't give the best bb-value, since the x-axis and y-axis
% are in different units and aren't normalized

% bb_vec=[];
% far_vec=[];
% frr_vec=[];
% bmin=av_girls_w-aa*av_girls_h;
% bmax=av_boys_w-aa*av_boys_h;
% for i=1:(bmax-bmin)
%     bb_tmp=bmin+1;
%     bb_vec=[bb_vec bb_tmp];

%     [far_tmp frr_tmp]=lms_validation(data_train,aa,bb_tmp,0); % I
%     modified lms_validation.m before but changed it back, that is why it
%     is an extra argument here

%     far_vec=[far_vec far_tmp];
%     frr_vec=[frr_vec frr_tmp];
% end
% opt_ind=find(min((far_vec+frr_vec)/2)); 
% bb=bb_vec(opt_ind);        

% Plot data   

plot(boys(:,1),boys(:,2),'r*')
hold on
plot(girls(:,1),girls(:,2),'bo')
hold on
plot([av_girls_h av_boys_h],[av_girls_w av_boys_w],'b--')
hold on
samples=[ boys(:,1:2) ; girls(:,1:2) ];
xx=[min(samples(:,1)):0.5:max(samples(:,1))]';
yy=aa*xx+bb;
plot(xx,yy,'g')
title('ORTHOGONAL with average TRAINING','Interpreter','Latex','FontSize',15);
hx = xlabel('$height$','FontSize',15);
set(hx,'Interpreter','Latex');
hy = ylabel('$weight$','FontSize',15);
set(hy,'Interpreter','Latex');
axis([150 200 50 110 ]);

%%%%%%%%%%%%%%%%%%%%% VALIDATION PART %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

true_boys=0;
true_girls=0;
false_boys=0;
false_girls=0;

% For each element in the dataset
for i=1:size(data_test,1)

    % Read features
    x=data_test(i,1);
    y=data_test(i,2);

    % Estimate yp given x
    yp = aa*x + bb;

    % If the estimated class is boy 
    if y*sign(aa)<yp*sign(aa)
        % ...and it is actually a boy
        if data_test(i,3)==0
            true_boys=true_boys+1;
        % ...but it is not a boy
        else
            false_boys=false_boys+1;
        end
    % If the estimated class is girl...
    else
        % ...and it is actually a girl
        if data_test(i,3)==1
            true_girls=true_girls+1;
        % ...but it is not a girl
        else
            false_girls=false_girls+1;
        end
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

% Define two arrays to store the data for boys and girls
[boys, girls] = build_datasets(data_test);

% Plot

figure
plot(boys(:,1),boys(:,2),'r*')
hold on
plot(girls(:,1),girls(:,2),'bo')
hold on
plot([av_girls_h av_boys_h],[av_girls_w av_boys_w],'b--')
hold on
samples=[ boys(:,1:2) ; girls(:,1:2) ];
xx=[min(samples(:,1)):0.5:max(samples(:,1))]';
yy=aa*xx+bb;
plot(xx,yy,'g')
title('ORTHOGONAL with average VALIDATION','Interpreter','Latex','FontSize',15);
hx = xlabel('$height$','FontSize',15);
set(hx,'Interpreter','Latex');
hy = ylabel('$weight$','FontSize',15);
set(hy,'Interpreter','Latex');
axis([150 200 50 110 ]);

% Display on the Matlab command line
disp(['FAR = ' num2str(far,'%.2f') ' (False Girls Rate)']);
disp(['FRR = ' num2str(frr,'%.2f') ' (False Boys Rate)']);
