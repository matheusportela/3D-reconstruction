function voxels = generate_voxels(qtd_x, qtd_y, qtd_z, N)
%% generate_voxels - creates a grid for the future carving
% ARGUMENTS:
%     qtd_x = inferior and superior limits of the X coordinate in the 3D
%     world - ex: [inf_x sup_x]
%     qtd_y = inferior and superior limits of the Y coordinate in the 3D
%     world - ex: [inf_x sup_x]
%     qtd_z = inferior and superior limits of the Z coordinate in the 3D
%     world - ex: [inf_x sup_x]
%     N = amount of voxels to be created
% 
% RETURNS: 
%     VOXELS = grid



volume = (qtd_x(2) - qtd_x(1)) * (qtd_y(2) - qtd_y(1)) * (qtd_z(2) - qtd_z(1));
voxels.Resolution = power( volume/N, 1/3 );
x = qtd_x(1) : voxels.Resolution : qtd_x(2);
y = qtd_y(1) : voxels.Resolution : qtd_y(2);
z = qtd_z(1) : voxels.Resolution : qtd_z(2);


[X,Y,Z] = meshgrid( x, y, z );
voxels.XData = X(:);
voxels.YData = Y(:);
voxels.ZData = Z(:);
voxels.Value = ones(numel(X),1);
