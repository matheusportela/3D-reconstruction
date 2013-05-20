function S = getsilhouette( im )
%GETSILHOUETTE - find the silhouette of an object centered in the image

%   Copyright 2005-2009 The MathWorks, Inc.
%   $Revision: 1.0 $    $Date: 2006/06/30 00:00:00 $
%close all;
%im  = cameras(1).Image;
[h,w,d] = size(im);

v = rgb2gray(im);

% Initial segmentation based on more red than blue
S = v(:,:,1) < (200);

% Remove regions touching the border or smaller than 10% of image area
S = imclearborder(S);
S = bwareaopen(S, ceil(h*w/10));

% Now remove holes < 1% image area
S = ~bwareaopen(~S, ceil(h*w/100));

%imshow(S);