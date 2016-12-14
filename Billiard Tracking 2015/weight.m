% function S_bar = weight(S_bar,Psi,outlier)
%           S_bar(t)            4XM
%           outlier             1Xn
%           Psi(t)              1XnXM
% Outputs: 
%           S_bar(t)            4XM
function S_bar = weight(S_bar,Psi,outlier)
% FILL IN HERE
%BE CAREFUL TO NORMALIZE THE FINAL WEIGHTS

    Psi(outlier==1)=1;
    Psi(outlier==0)=Psi(outlier==0)+1;
	w=prod(Psi,1);
    w(w==1)=0;
    
    S_bar(3,:)=w;

%     p=max(Psi,[],1);
% 
%     if(sum(p)==0)
%         S_bar(3,:)=1/size(S_bar,2);
%     else
%         S_bar(3,:)=p/sum(p);
%     end
end

