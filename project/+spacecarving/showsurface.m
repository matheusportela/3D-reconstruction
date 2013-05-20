function ptch = showsurface( voxels )
% showsurface( voxels )
%  This function is used to draw a surface based on the provided voxels 
%  structure. It uses Matlab's ISOSURFACE command to do that.
% 
% ARGUMENTS:
% VOXELS = this argument contains the voxels to be drawn. 
%
% RETURNS:
% PTCH = SHOWSURFACE(VOXELS) also returns handles to the patches created.
%

% First, puts the data in a grid
data_x = unique(voxels.XData);
data_y = unique(voxels.YData);
data_z = unique(voxels.ZData);

% Then, expands the model in each direction by one step
data_x = [data_x(1)-voxels.Resolution; data_x; data_x(end)+voxels.Resolution];
data_y = [data_y(1)-voxels.Resolution; data_y; data_y(end)+voxels.Resolution];
data_z = [data_z(1)-voxels.Resolution; data_z; data_z(end)+voxels.Resolution];

% Convert to a grid
[X,Y,Z] = meshgrid( data_x, data_y, data_z );

% Create a voxel grid with empty spaces, and fill only those elements 
% where voxels are present.
V = zeros( size( X ) );
N = numel( voxels.XData );
for ii=1:N
    ix = (data_x == voxels.XData(ii));
    iy = (data_y == voxels.YData(ii));
    iz = (data_z == voxels.ZData(ii));
    V(iy,ix,iz) = voxels.Value(ii);
end

% Now draw it
ptch = patch( isosurface( X, Y, Z, V, 0.5 ) );
isonormals( X, Y, Z, V, ptch )
set( ptch, 'FaceColor', 'g', 'EdgeColor', 'black' );

set(gca,'DataAspectRatio',[1 1 1]);
xlabel('X');
ylabel('Y');
zlabel('Z');
view(-140,22)
lighting( 'gouraud' )
camlight( 'right' )
axis( 'tight' )
