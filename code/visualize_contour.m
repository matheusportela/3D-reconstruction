close all

%% Initial configurations
addpath('code/third_party')

%% Read images
nImages = 2;
colors = ['r' 'g' 'b' 'y' 'k'];

for image_number = 0:(nImages - 1);

% Read image
image = read_image(image_number);

% Read countour
contour = read_contour(image_number);

% Read calibration
[C, Rc, Tc] = read_calibration(image_number);

% Visualize image
figure(image_number + 2);
imshow(image);
hold on;
plot(contour(:, 1), contour(:, 2), 'go');

figure(1);
% Plot camera positions
plot3([0 Tc(1)], [0 Tc(2)], [0 Tc(3)], 'b-');
hold on;
grid on;
drawnow;

%figure;
%image_corners = corner(rgb2gray(image), 1000);
%imshow(image);
%hold on
%plot(image_corners(:,1), image_corners(:,2), 'r*');

end