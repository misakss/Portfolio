%combind all parts of the particle filter and get measurments from
%circle_detection

%Open movie

%Place N particles in the area

%Main loop
    %Get next image in video
    %Process image and get z
    %K-means N clusters
    %Diffusion and propegation (gives prediction)
    %Weighting
    %for each clustering
    %   Resampling (stratified (clusters) and systematic?)
    
    %get centrum from each cluster
    
    %Save image and the circles in a vid (centrum from particle filter)
%end loop


%Evaluate the noise in measurmenets per clusters -> cluster weight ->
%outlier cluster?

%https://hal.inria.fr/inria-00072605/document


%Too many detections on the balls -> too many measurements -> weight
%becomes close enought to zero to be zero (can see it eiter as the more measurements, the lower the chance is to have a good value which means lower 
% likelyhood, or as when multiplying in weight, even a high likelyhood becomes small when taking it to the power of 250)