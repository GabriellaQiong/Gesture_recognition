function [centroids, K] = get_centroids(data, K, D)
% GET_CENTROIDS() creates histogram to bin the data
% Written by Qiong Wang at University of Pennsylvania
% 02/29/2014

% mu = zeros(size(data, 1), D);
% for n = 1:size(data,1)
%     for i = 1:size(data,2)
%         for j = 1:D
%             mu(n,j) = mu(n,j) + data(n,i,j);
%         end
%     end
%     mu(n,:) = mu(n,:)./size(data,2);
% end

% mu = [];
% for j = 1 : D
%     temp = data(:, :, j); 
%     mu = [mu temp(:)];
% end

numData = numel(data);
mu      = [];
for i = 1 : numData
    mu = [mu; data{i}(:, 1 : D)];
end

% Using k-means to make data discrete
% [centroids, ~, ~] = kmeans(mu, K);
% K = size(centroids,1);
[~, centroids] = kmeans(mu, K);

% numData = numel(data);
% mu      = [];
% for i = 1 : numData
%     mu = [mu; data{i}(:, 1 : D)];
% end
% 
% centroids = zeros(K, D);
% for j = 1 : D
%     [~, centroids(:, D)] = hist(mu(:, j), K);
% end

end