function [K, R, t] = decomposeP(P)
% decomposeP(P): This function decomposes the camera calibration matrix
% into the intrinsic and extrinsic parameters using the QR decomposition
%
%
% ARGUMENTS:
% P = the 3x4 camera calibration matrix
%
%
% RETURNS:
% K = the 3x3 intrinsic parameters matrix
%
% R = the 3x3 rotation matrix (extrinsic parameters)
%
% t = the 3x1 translation matrix (extrinsic parameters)
%

% QR decomposition
[q, r] = qr(inv(P(1:3, 1:3)));

K_inverse = r(1:3,1:3); % the decomposed R returns the inverse of K
R = inv(q); % the inverse of Q returns the rotation matrix

% change the sign when the determinant of R is negative
if sign(det(R)) == -1
    K_inverse = -K_inverse;
    R = -R;
end

t = K_inverse * P(:,4); % generating the translation matrix
K = inv(K_inverse);
