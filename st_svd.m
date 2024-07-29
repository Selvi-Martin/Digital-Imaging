function normalized_image = svd_based_normalization(input_image, target_image)
    % Convert RGB images to Lab color space
    input_lab = rgb2lab(input_image);
    target_lab = rgb2lab(target_image);

    % Reshape Lab color channels for SVD computation
    input_lab_reshaped = reshape(input_lab, [], 3);
    target_lab_reshaped = reshape(target_lab, [], 3);

    % Perform Singular Value Decomposition (SVD) on the Lab color channels
    [U_input, S_input, V_input] = svd(input_lab_reshaped(:,2:3), 'econ');
    [U_target, S_target, V_target] = svd(target_lab_reshaped(:,2:3), 'econ');

    % Compute the transformation matrices
    T = V_target * inv(S_target) * U_target' * U_input * S_input * V_input';

    % Apply the transformation to the input image
    normalized_lab_reshaped = input_lab_reshaped;
    normalized_lab_reshaped(:,2:3) = (T * normalized_lab_reshaped(:,2:3)')';

    % Reshape the normalized Lab image to its original size
    normalized_lab = reshape(normalized_lab_reshaped, size(input_lab));

    % Convert back to RGB
    normalized_image = lab2rgb(normalized_lab);
end


% Read source and target RGB images
source_image = imread('/MATLAB Drive/stain_method/image/_2021-07-19_03_05_16_No_0_x_27092.0_y_25008.0.jpg');
target_image = imread('/MATLAB Drive/stain_method/mac_norm_img/_2021-07-19_03_05_16_No_0_x_27092.0_y_25008.0_normalized.jpg');

% Perform SVD-based stain normalization
normalized_image = svd_based_normalization(source_image, target_image);

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
title('SVD Normalized Image');
