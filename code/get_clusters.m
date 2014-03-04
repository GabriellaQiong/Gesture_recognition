function XClustered = get_clusters(data, centroids, D)
% GET_CLUSTERS() find the currect bin for the data
% Written by Qiong Wang at University of Pennsylvania
% 02/29/2014

% XClustered = cell(size(data, 2), 1);
% K          = size(centroids,1);
% 
% for n = 1:size(data,1)
%     for i = 1:size(data,2)
%         temp = zeros(K,1);
%         for j = 1:K
%            temp(j) = sqrt(sum((centroids(j, 1 : D) - squeeze(data(n, i, 1 : D))').^2, 2));
%         end
%         [~, I] = min(temp);
%         XClustered{i}(n,1) = I(1);
%     end
% end

XClustered = cell(1, numel(data));
K          = size(centroids,1);
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

% I          = zeros(K, D);
% for n = 1 : numel(data)
%     for i = 1 : size(data{n}, 1)
%         temp = zeros(K,1);
%         for j = 1 : K
%             for dim = 1 : D
%                 temp(j, dim) = sqrt(sum((centroids(j, dim) - data{n}(i, dim)).^2, 2));
%             end
%         end
%         for dim = 1 : D
%             [~, I(:, dim)] = min(temp(:, dim));
%         end
%         XClustered{n}(1, i) = sub2ind([K, K, K], I(1, 1), I(1, 2), I(1, 3));
%     end
% end
