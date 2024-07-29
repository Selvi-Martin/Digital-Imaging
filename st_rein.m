function normalized_image = reinhard_stain_normalization(source_image, target_image)
    % Convert RGB images to Lab color space
    source_lab = rgb2lab(source_image);
    target_lab = rgb2lab(target_image);

    % Compute mean and standard deviation of each channel in source and target images
    source_mean = mean(reshape(source_lab, [], 3), 1);
    target_mean = mean(reshape(target_lab, [], 3), 1);
    source_std = std(reshape(source_lab, [], 3));
    target_std = std(reshape(target_lab, [], 3));

    % Perform stain normalization
    normalized_image = source_image;
    for channel = 1:3
        normalized_image(:, :, channel) = ...
            (source_image(:, :, channel) - source_mean(channel)) * (target_std(channel) / source_std(channel)) + target_mean(channel);
    end

    % Clip pixel values to [0, 255] range
    normalized_image = max(0, min(normalized_image, 255));

    % Convert to uint8
    normalized_image = uint8(normalized_image);
end
% Read source and target RGB images
source_image = imread('/MATLAB Drive/stain_method/image/_2021-07-19_03_05_16_No_0_x_27092.0_y_25008.0.jpg');
target_image = imread('/MATLAB Drive/stain_method/mac_norm_img/_2021-07-19_03_05_16_No_0_x_27092.0_y_25008.0_normalized.jpg');

% Perform Reinhard stain normalization
normalized_image = reinhard_stain_normalization(source_image, target_image);

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
title('Reinhard  Image');
