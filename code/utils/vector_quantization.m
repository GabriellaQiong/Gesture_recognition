function vector_quantization(data)
% VECTOR_QUANTIZATION()  
% Written by Qiong Wang at University of Pennsylvania
% 02/28/2014

[~, clusters] = kmeans(data, K, 10);
numClusters   = numel(clusters);
.num_code=K;
.code=clusters(1:sz-floor(0.05*sz));
.obs=imu(:,1:numel(codebook.code));
end