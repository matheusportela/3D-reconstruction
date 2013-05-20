function colorsurface( ptch, cameras )
% colorsurface( ptch, cameras )
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
    cam_normals(:,ii) = spacecarving.getcameradirection( cameras(ii) );
end

% Use the normal to find the best camera and view the value.
v_data = zeros( num_vert, 3 );
for ii=1:num_vert
    % Find the best camera
    angles = normals(ii,:)*cam_normals./norm(normals(ii,:));
    [~,cam_idx] = min( angles );
    % And projects the vertex into the chosen one
    [imx,imy] = spacecarving.project( cameras(cam_idx), ...
        vert(ii,1), vert(ii,2), vert(ii,3) );
    v_data(ii,:) = double( cameras(cam_idx).Image( round(imy), round(imx), : ) )/255;
end

% Set it into the patch
set( ptch, 'Facev_data', v_data, 'FaceColor', 'interp' );