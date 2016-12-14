% function S = systematic_resample(S_bar)
% This function performs systematic re-sampling
% Inputs:   
%           S_bar(t):       4XM
% Outputs:
%           S(t):           4XM
function S = systematic_resample(S_bar)
% FILL IN HERE
    M=size(S_bar,2);
    if(S_bar(3,:)==0)
        S_bar(3,:)=1/M;
    else
        S_bar(3,:)=S_bar(3,:)/sum(S_bar(3,:));
    end
    limiters=cumsum(S_bar(3,:));
    r=rand/M+(0:(M-1))'/M;
    [~,i]=max(bsxfun(@ge,limiters,r),[],2);
    S(1:2,:)=S_bar(1:2,i);
    S(3,:)=1/M;
end