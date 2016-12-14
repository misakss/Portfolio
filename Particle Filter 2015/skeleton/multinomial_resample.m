% function S = multinomial_resample(S_bar)
% This function performs systematic re-sampling
% Inputs:   
%           S_bar(t):       4XM
% Outputs:
%           S(t):           4XM
function S = multinomial_resample(S_bar)
% FILL IN HERE
    wd=cumsum(S_bar(4,:));
    r=rand(size(S_bar,2),1);
    bir=repmat(wd,1,size(wd,2))>=repmat(r,size(wd,2),1)';
    [~,i]=max(bir,[],2);
    S(1:3,:)=S_bar(1:3,i);
    S(4,:)=1/size(S_bar,2);
end
