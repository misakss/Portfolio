function S = stratified_resample(S_bar)
% FILL IN HERE
    w=S_bar(3,:);
    N = length(w);
    if(sum(w)==0)
        w=ones(1,N)/N;
    else
        w=w./sum(w);
    end
    
    Q = cumsum(w);
    T=zeros(1,N);
    for i=1:N,
        T(i) = rand(1,1)/N + (i-1)/N;
    end
    T(N+1) = 1;

    i=1;
    j=1;

    while (i<=N),
        if (T(i)<Q(j)),
            indx(i)=j;
            i=i+1;
        else
            j=j+1;        
        end
    end
    S(:,:)=S_bar(:,indx);
    S(3,:)=1/N;
end