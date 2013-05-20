function normal_vector = get_normal_vector(camera)
%  get_normal_vector(camera)
%   This function returns a unitary 3D vector pointing to the direction
%   focused by camera
%
%
% ARGUMENTS:
% CAMERA = Camera struct
%
%
% RETURNS:
% NORMAL_VECTOR = Unitary vector
%

% Image sizes in the X and Y axes
size_x = size(camera.Image, 2);
size_y = size(camera.Image, 1);

% Homogeneous centre point of the image
centre = [size_x/2
          size_y/2
          1.0];

% Project point to 3D
X = camera.K\centre; % equivalent to inv(camera.K)*centre

% Apply rotation
X = camera.R'*X;

% Normalise to transform to 3D
normal_vector = X./norm(X);