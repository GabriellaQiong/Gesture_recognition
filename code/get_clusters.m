function XClustered = get_clusters(data, centroids, D)
% GET_CLUSTERS() find the currect bin for the data
% Written by Qiong Wang at University of Pennsylvania
% 02/29/2014

XClustered = cell(1, numel(data));
K          = size(centroids,1);

% for n = 1:size(data,1)
%     for i = 1:size(data,2)
%         temp = zeros(K,1);
%         for j = 1:K
%            temp(j) = sqrt(sum((centroids(j, 1 : D) - squeeze(data(n, i, 1 : D))').^2, 2));
%         end
%         [~, I] = min(temp);
%         XClustered{i}(n,1) = I(1);
% %         XClustered{i} = kmeans(squeeze(data(:, i, :)), K); 
%     end
% end

for n = 1 : numel(data)
    for i = 1 : size(data{n}, 1)
        temp = zeros(K,1);
        for j = 1 : K
            temp(j) = sqrt(sum((centroids(j, 1 : D) - data{n}(i, 1 : D)).^2, 2));
        end
        [~, I] = min(temp);
        XClustered{n}(1, i) = I(1);
    end
end
