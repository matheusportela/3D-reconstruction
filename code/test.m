volume = diff( xlim ) * diff( ylim ) * diff( zlim );
voxels.Resolution = power( volume/N, 1/3 );
x = xlim(1) : voxels.Resolution : xlim(2);
y = ylim(1) : voxels.Resolution : ylim(2);
z = zlim(1) : voxels.Resolution : zlim(2);


[X,Y,Z] = meshgrid( x, y, z );
voxels.XData = X(:);
voxels.YData = Y(:);
voxels.ZData = Z(:);
voxels.Value = ones(numel(X),1);