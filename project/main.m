% Eduardo Neiva - u5257353
% Luiz Moreira - u5250345
% Matheus Portela - u5250333
% Thiago Oliveira - u5249937
% ENGN4528 - COMPUTER VISION PROJECT
% PROJECT 1

resolution = 500000;
addpath('../data/contour')
addpath('../data/images')
%% Setup
%It is loaded all the functions and the imagepath
datadir = fullfile( fileparts( mfilename( 'fullpath' ) ), 'data' );
close all;


%% Load the Camera and Image Data
% This reads the "/data/images" directory, loading the camera definitions
% (internal and external calibration) and image file for each camera.
cameras = load_cameras( datadir );





%% Generate the Silhouttes
% Generate the silhouettes based on the points provided as contour
% Some image dilation and erosion are used to conect the points.
SI = generate_silhouettes();
for c=1:numel(cameras)
    cameras(c).Silhouette = SI(c).si;
end



%% Work out the space occupied by the scene
%In this part, we define a standard volume that the voxels will be placed
%at, in other words, this is the space xyz that the intial voxel structure
%will be placed so it can be carved. Increasing this world we have a
%greater volume coverage but each voxel will be more spread which would
%result in a 3D model with less resolution.
test = 1000;

x_boundaries = [120, 600];
y_boundaries = [120, 550];
z_boundaries = [-100, 550];

%% Create a Voxel Array
% in this part, we create a voxel 3d mapping within those limits defined before.
% the forth argument indicates how many voxels there will be in each
% component xyz, thereby increasing this number reduces the spread between
% each voxel and increases the accuracy of the model. This comes at a cost
% of a increased run time and memory usage.
voxels = generate_voxels( x_boundaries, y_boundaries, z_boundaries, resolution );



%% Carving
% Now, using every camera position, we carve the voxels using their
% sillhuete.
for ii=1:numel(cameras)
    voxels = projection_carve( voxels, cameras(ii) );
end
figure();
build_model(voxels);
grid on;
title( '3D Morpheus Reconstruction Model' )

