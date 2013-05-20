function [X_2D, Y_2D] = project( camera, X_3D, Y_3D, Z_3D )
%% project: project a 3d-point into a 2d-point.
% ARGUMENTS:
% 
%     CAMERA = Camera information. Needs only the matrix P, that contains
%     the rotation and the translation of the camera in relation to the
%     center point coordinates.
%     X_3D = x coordinate on 3-dimensional world
%     Y_3D = y coordinate on 3-dimensional world
%     Z_3D = z coordinate on 3-dimensional world
% 
% RETURNS:
%     X_2D = x coordinate on 2-dimensional image
%     Y_2D = y coordinate on 2-dimensional image

P = camera.rawP;

k = P(3,1) * X_3D + P(3,2) * Y_3D + P(3,3) * Z_3D + P(3,4);
Y_2D = round( (P(2,1) * X_3D + P(2,2) * Y_3D + P(2,3) * Z_3D + P(2,4)) ./ k);
X_2D = round( (P(1,1) * X_3D + P(1,2) * Y_3D + P(1,3) * Z_3D + P(1,4)) ./ k);
