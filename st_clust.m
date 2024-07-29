function normalized_image = cluster_based_normalization(input_image, target_image, num_clusters)
    % Convert RGB images to Lab color space
    input_lab = rgb2lab(input_image);
    target_lab = rgb2lab(target_image);

    % Reshape Lab color channels for clustering
    input_lab_reshaped = reshape(input_lab, [], 3);
    target_lab_reshaped = reshape(target_lab, [], 3);

    % Perform clustering on Lab color channels
    input_lab_clusters = kmeans(input_lab_reshaped, num_clusters);
    target_lab_clusters = kmeans(target_lab_reshaped, num_clusters);

    % Compute cluster centroids for input and target images
    input_centroids = zeros(num_clusters, 3);
    target_centroids = zeros(num_clusters, 3);
    for i = 1:num_clusters
        input_centroids(i, :) = mean(input_lab_reshaped(input_lab_clusters == i, :), 1);
        target_centroids(i, :) = mean(target_lab_reshaped(target_lab_clusters == i, :), 1);
    end

    % Perform cluster-based normalization
    normalized_lab_reshaped = input_lab_reshaped;
    for i = 1:num_clusters
        cluster_indices = input_lab_clusters == i;
        normalized_lab_reshaped(cluster_indices, 2:3) = ...
            bsxfun(@minus, input_lab_reshaped(cluster_indices, 2:3), input_centroids(i, 2:3)) + target_centroids(i, 2:3);
    end

    % Reshape the normalized Lab image to its original size
    normalized_lab = reshape(normalized_lab_reshaped, size(input_lab));

    % Convert back to RGB
    normalized_image = lab2rgb(normalized_lab);
end

% Read source and target RGB images
source_image = imread('/MATLAB Drive/stain_method/image/_2021-07-19_03_05_16_No_0_x_27092.0_y_25008.0.jpg');
target_image = imread('/MATLAB Drive/stain_method/mac_norm_img/_2021-07-19_03_05_16_No_0_x_27092.0_y_25008.0_normalized.jpg');

% Perform SVD-based stain normalization
normalized_image = cluster_based_normalization(source_image, target_image,5);

% Display source, target, and normalized images
figure;
subplot(1, 3, 1);
imshow(source_image);
title('Source Image');
subplot(1, 3, 2);
imshow(target_image);
title('Target Image');
subplot(1, 3, 3);
imshow(normalized_image);
title('cluster Normalized Image');