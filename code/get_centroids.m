function [centroids, K] = get_centroids(data, K, D)
% GET_CENTROIDS() creates histogram to bin the data
% Written by Qiong Wang at University of Pennsylvania
% 02/29/2014

mean = zeros(size(data,1), D);
for n = 1:size(data,1)
    for i = 1:size(data,2)
        for j = 1:D
            mean(n,j) = mean(n,j) + data(n,i,j);
        end
    end
    mean(n,:) = mean(n,:)./size(data,2);
end

% Using k-means to make data discrete
[centroids, ~, ~] = kmeans(mean, K);
K = size(centroids,1);
end