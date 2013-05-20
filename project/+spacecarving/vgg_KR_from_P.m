
function [K, R, t] = vgg_KR_from_P(P, noscale)
% This function was used in the C-LAB 6, so we are basicly reusing it since
% it was necessary to uqet the K,R,T values from a 
%
%VGG_KR_FROM_P Extract K, R from camera matrix.
%
%    [K,R,t] = VGG_KR_FROM_P(P [,noscale]) finds K, R, t such that P = K*R*[eye(3) -t].
%    It is det(R)==1.
%    K is scaled so that K(3,3)==1 and K(1,1)>0. Optional parameter noscale prevents this.
%
%    Works also generally for any P of size N-by-(N+1).
%    Works also for P of size N-by-N, then t is not computed.


% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Modified by werner.
% Date: 15 May 98

N = size(P,1);
H = P(:,1:N);

[K,R] = vgg_rq(H);
  
if nargin < 2
  K = K / K(N,N);
  if K(1,1) < 0
    D = diag([-1 -1 ones(1,N-2)]);
    K = K * D;
    R = D * R;
    
  %  test = K*R; 
  %  vgg_assert0(test/test(1,1) - H/H(1,1), 1e-07)
  end
end

if nargout > 2
  t = -P(:,1:N)\P(:,end);
end

return


% [R,Q] = vgg_rq(S)  Just like qr but the other way around.
%
% If [R,Q] = vgg_rq(X), then R is upper-triangular, Q is orthogonal, and X==R*Q.
% Moreover, if S is a real matrix, then det(Q)>0.

% By awf

function [U,Q] = vgg_rq(S)

S = S';
[Q,U] = qr(S(end:-1:1,end:-1:1));
Q = Q';
Q = Q(end:-1:1,end:-1:1);
U = U';
U = U(end:-1:1,end:-1:1);

if det(Q)<0
  U(:,1) = -U(:,1);
  Q(1,:) = -Q(1,:);
end

return