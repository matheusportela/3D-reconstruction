function cameras = loadcameradata(data_directory)
% loadcameradata(data_directory, cameraIndex): Generate a camera struct
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

import spacecarving.*;

num_cameras = 23;

% Defining camera struct
cameras = struct('Image', {}, ...
                 'P', {}, ...
                 'K', {}, ...
                 'R', {}, ...
                 'T', {}, ...
                 'Silhouette', {});


% Loading calibration matrices P
rawP = load(fullfile(data_directory, 'morp.mat'));

% Load all structs
for ii = 1:num_cameras
    % Get the image file name
    filename = fullfile(data_directory, sprintf('%d.jpg', ii-1));
    
    % Decompose matrices
    [K, R, t] = spacecarving.vgg_KR_from_P(rawP.P{ii});
    
    % Load data
    cameras(ii).Image = imread(filename);
    cameras(ii).rawP = rawP.P{ii};
    cameras(ii).P = rawP.P{ii};
    cameras(ii).K = K./K(3,3); % remove the scaling by K(3, 3) as 1
    cameras(ii).R = R;
    cameras(ii).T = -R'*t;
    cameras(ii).Silhouette = []; % empty silhouette
end

