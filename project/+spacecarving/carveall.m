function voxels = carveall( voxels, cameras )
% carvelall( voxels, cameras ) this function is used to carve the initial
% voxel matrix using a set of cameras.
%
%  VOXELS = initial voxels that will be used in the carving - this should
%  be initialized before calling this function
%
% CAMERAS = all the cameras that will be used in the carving process. All
% the cameras contains their information of its sillhuete
%

for ii=1:numel(cameras);
    voxels = carve(voxels,cameras(ii));
end