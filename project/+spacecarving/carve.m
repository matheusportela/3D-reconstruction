function [voxels,voxelsKept] = carve( voxels, camera )
% carve( voxels, camera )
%  This function is used to remove all the voxels that are outside of the
%  sillhouete, creating a carving effect.
% 
% ARGUMENTS:
% VOXELS = this arguments contains the voxels to be cropped. The amount of
% voxels will reduce as the number of carves is increased.
%
%
% CAMERA = this is a struct that contains all the information of the that
% image. Thus, the sillhouete of the camera can be accessed as
% camera.Sillhouete
%
%
% RETURNS:
% VOXELS = the returned voxels will contain the next voxel matrix with the
% camera sillhouete carve applied onto it
%
% KEEP = contain the indeces of the voxel that were kept during the process
% of carving


% Project into image
[x,y] = spacecarving.project( camera, voxels.XData, voxels.YData, voxels.ZData );

%From all the voxels continaed initially, remove all those are not in the
%image
[h,w,d] = size(camera.Image); 
voxelsKept = find( (x>=1) & (x<=w) & (y>=1) & (y<=h) );

%update the x and y values removing the values not necessary.
x = x(voxelsKept);
y = y(voxelsKept);

% this is the proper carving, this create a matrix of indices that will
% refer to voxels that will be removed and kept.
ind = sub2ind( [h,w], round(y), round(x) );
voxelsKept = voxelsKept(camera.Silhouette(ind) >= 1);

%update the voxels with the new carved voxels
voxels.XData = voxels.XData(voxelsKept);
voxels.YData = voxels.YData(voxelsKept);
voxels.ZData = voxels.ZData(voxelsKept);
voxels.Value = voxels.Value(voxelsKept);
