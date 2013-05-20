function S = getsilhouette(ii, Silhouettes)
% getsilhouette(ii, SI):
%    Return the ii-th silhouette image
%
% ARGUMENTS:
% II = Silhouette index
% SILHOUETTES = Silhouettes struct
%
% RETURNS:
% S = ii-th silhouette image
%

S = Silhouettes(ii).si;