function normalized_image = vahadane_stain_normalization(input_image)
    % Convert RGB image to optical density space
    optical_density = -log((double(input_image) + 1) / 256);

    % Reshape the optical density values
    optical_density = reshape(optical_density, [], 3);

    % Perform Non-negative Matrix Factorization (NNMF) to estimate stain matrix
    [W, ~] = nnmf(optical_density, 2);

    % Rescale the stain matrix
    max_OD = max(optical_density, [], 1);

    % Stain normalization
    transformed_OD = optical_density ./ max_OD;

    % Rescale the transformed optical density
    transformed_OD = transformed_OD - min(transformed_OD(:));
    transformed_OD = transformed_OD ./ max(transformed_OD(:));

    % Convert back to RGB
    normalized_image = exp(-reshape(transformed_OD, size(input_image, 1), size(input_image, 2), 3));
    normalized_image = normalized_image ./ max(normalized_image(:)) * 255;

    % Convert to uint8
    normalized_image = uint8(normalized_image);
end

input_dir = '/MATLAB Drive/stain_method/image';
output_dir = '/MATLAB Drive/stain_method/vah_norm_img';
% Get a list of all image files in the input directory
image_files = dir(fullfile(input_dir, '*.jpg'));
% Loop over each image file
for i = 1:numel(image_files)
    % Read the input image
   input_image = imread(fullfile(input_dir, image_files(i).name));
    
    % Call the vahadane_normalization function to normalize the image
    normalized_image = vahadane_stain_normalization(input_image);
    
    % Save the normalized image to the output directory
    [~, filename, ext] = fileparts(image_files(i).name);
    output_filename = fullfile(output_dir, [filename '_normalized' ext]);
    imwrite(normalized_image, output_filename);
end

