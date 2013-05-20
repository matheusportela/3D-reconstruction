function build_coloured_model( ptch, cameras )
% coloured_model( ptch, cameras )
%   This function 'paints' the 3D model based on the colors from the
%   original images. It uses the nearest image pixel to get the color.
%
% ARGUMENTS:
% PTCH = this argument contains the 3D model to be colored. 
% CAMERAS = this argument contains the images from which the colors are
% extracted.
%

vert = get( ptch, 'Vertices' );
normals = get( ptch, 'VertexNormals' );
num_vert = size( vert, 1 );

% For each camera, get the view vector
num_cam = numel( cameras );
cam_normals = zeros( 3, num_cam );
for ii=1:num_cam
    cam_normals(:,ii) = get_normal_vector( cameras(ii) );
end

% Use the normal to find the best camera and view the value.
vertexcdata = zeros( num_vert, 3 );
for ii=1:num_vert
    % Find the best camera
    angles = normals(ii,:)*cam_normals./norm(normals(ii,:));
    [~,cam_idx] = min( angles );
    % And projects the vertex into the chosen one
    [imx,imy] = project_3d_to_2d( cameras(cam_idx), ...
        vert(ii,1), vert(ii,2), vert(ii,3) );
    vertexcdata(ii,:) = double( cameras(cam_idx).Image( round(imy), round(imx), : ) )/255;
end

% Set it into the patch
set( ptch, 'Facevertexcdata', vertexcdata, 'FaceColor', 'interp' );