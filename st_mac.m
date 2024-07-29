function normalized_image = macenko_stain_normalization(image)
    % Convert image to Lab color space
    lab_image = rgb2lab(image);

    % Extract the L, a, and b channels
    L = lab_image(:,:,1);
    a = lab_image(:,:,2);
    b = lab_image(:,:,3);

    % Reshape a and b channels into 1D arrays
    a = reshape(a, [], 1);
    b = reshape(b, [], 1);

    % Convert a and b channels to double precision
    a = double(a);
    b = double(b);

    % Calculate mean and standard deviation of a and b channels
    mean_a = mean(a);
    mean_b = mean(b);
    std_a = std(a);
    std_b = std(b);

    % Set target stain vectors (Macenko method)
    target_a = 190 * (a - mean_a) / std_a;
    target_b = 190 * (b - mean_b) / std_b;

    % Reshape target a and b channels to original image size
    target_a = reshape(target_a, size(image, 1), size(image, 2));
    target_b = reshape(target_b, size(image, 1), size(image, 2));

    % Create normalized Lab image
    normalized_lab_image = cat(3, L, target_a, target_b);

    % Convert normalized Lab image to RGB
    normalized_image = lab2rgb(normalized_lab_image);
end
input_dir = '/MATLAB Drive/stain_method/image';
output_dir = '/MATLAB Drive/stain_method/mac_norm_img';
% Get a list of all image files in the input directory
image_files = dir(fullfile(input_dir, '*.jpg'));
% Loop over each image file
for i = 1:numel(image_files)
    % Read the input image
   input_image = imread(fullfile(input_dir, image_files(i).name));
    
    % Call the vahadane_normalization function to normalize the image
    normalized_image = macenko_stain_normalization(input_image);
    
    % Save the normalized image to the output directory
    [~, filename, ext] = fileparts(image_files(i).name);
    output_filename = fullfile(output_dir, [filename '_normalized' ext]);
    imwrite(normalized_image, output_filename);
end

