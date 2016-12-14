% function S = systematic_resample(S_bar)
% This function performs systematic re-sampling
% Inputs:   
%           S_bar(t):       4XM
% Outputs:
%           S(t):           4XM
function S = systematic_resample(S_bar)
% FILL IN HERE
    M=size(S_bar,2);
    wd=cumsum(S_bar(4,:));
    r=rand/M+(0:(M-1))'/M;
    bir=repmat(wd,M,1)>=repmat(r,1,M);
    [~,i]=max(bir,[],2);
    S(1:3,:)=S_bar(1:3,i);
    S(4,:)=1/M;
end
