function cameras = load_cameras(data_directory)
% load_cameras(data_directory): Generate a camera struct
%   which contains all important data: the image itself, calibration
%   matrices and the silhouette image
%
%
% ARGUMENTS:
% data_directory = Directory which contains the necessary data
%
% RETURNS:
% CAMERAS = Struct with the camera data
%


num_cameras = 23;

% Defining camera struct
cameras = struct('Image', {}, ...
                 'P', {}, ...
                 'K', {}, ...
                 'R', {}, ...
                 'T', {}, ...
                 'Silhouette', {});


% Loading calibration matrices P
P_matrices = load(fullfile(data_directory, 'morp.mat'));

% Load all structs
for ii = 1:num_cameras
    % Get the image file name
    filename = fullfile(data_directory, sprintf('%d.jpg', ii-1));
    
    % Decompose matrices
    [K, R, t] = vgg_KR_from_P(P_matrices.P{ii});
    
    % Load data
    cameras(ii).Image = imread(filename);
    cameras(ii).P = P_matrices.P{ii};
    cameras(ii).K = K./K(3,3); % remove the scaling by K(3, 3) as 1
    cameras(ii).R = R;
    cameras(ii).T = -R'*t;
    cameras(ii).Silhouette = []; % empty silhouette
end

