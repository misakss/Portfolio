% function S_bar = weight(S_bar,Psi,outlier)
%           S_bar(t)            4XM
%           outlier             1Xn
%           Psi(t)              1XnXM
% Outputs: 
%           S_bar(t)            4XM
function S_bar = weight(S_bar,Psi,outlier)
% FILL IN HERE
%BE CAREFUL TO NORMALIZE THE FINAL WEIGHTS
    wp=prod(Psi(1,~outlier,:),2);
    if(sum(wp)==0)
        S_bar(4,:)=1/size(S_bar,2);
    else
        S_bar(4,:)=wp/sum(wp);
    end
end
