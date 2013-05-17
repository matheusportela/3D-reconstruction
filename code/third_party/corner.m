function varargout = corner(varargin)
% CORNER Find corner points in an image.
%   CORNERS = CORNER(I) takes a grayscale or binary image I as its input
%   and returns CORNERS. The M-by-2 double matrix CORNERS  contains the X
%   and Y coordinates of the corner points detected in I.
%
%   CORNERS = CORNER(I,METHOD) detects corners in the grayscale or binary
%   image I using the specified METHOD.  Supported METHODs are:
%
%      'Harris'            : The Harris corner detector. This is the
%                                  default METHOD.
%      'MinimumEigenvalue' : Shi & Tomasi's minimum eigenvalue method.
%
%   CORNERS = CORNER(I,N) detects corners in the grayscale or binary
%   image I and returns a maximum of N corners. If N is not specified,
%   the default maximum number of corners returned is 200.
%
%   CORNERS = CORNER(I,METHOD,N) detects corners using the specified METHOD
%   and maximum number of corners.
%
%   CORNERS = CORNER(...,PARAM1,VAL1,PARAM2,VAL2,...) detects corners in I,
%   specifying parameters and corresponding values that control various
%   aspects of the corner detection algorithm.
%
%   Parameter options:
%   -------------------
%
%   'FilterCoefficients'     A vector, V, of filter coefficients for the
%                            separable smoothing filter. The full filter 
%                            kernel is given by the outer product, V*V'. 
%
%                            Default value: fspecial('gaussian',[5 1],1.5)
%
%   'QualityLevel'           A scalar Q, 0 < Q < 1, specifying the minimum 
%                            accepted quality of corners. The value of Q 
%                            is multiplied by the largest corner
%                            metric value. Candidate corners that have
%                            corner metric values less than the product are
%                            rejected. Larger values of Q can be used to
%                            remove erroneous corners.
% 
%                            Default value: 0.01
%
%   'SensitivityFactor'      A scalar K, 0 < K < 0.25, specifying the
%                            sensitivity factor used in the Harris
%                            detection algorithm. The smaller the value
%                            of K the more likely the algorithm is to
%                            detect sharp corners. This parameter is only
%                            valid with the 'Harris' method.
%
%                            Default value: 0.04
%
% Notes
% -----
% Non-maxima suppression is performed on candidate corners. Corners will be
% at least two pixels apart.
%
% Example
% -------
% Find and plot corner points in checkerboard image.
%
%        I = checkerboard(50,2,2);
%        corners = corner(I);
%        imshow(I);
%        hold on
%        plot(corners(:,1),corners(:,2),'r*');
%
% See also CORNERMETRIC

%   Copyright 2010 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2010/08/07 07:27:17 $

% parse inputs
[I,method,sensitivity_factor,...
    filter_coef,max_corners,quality_level] = parseInputs(varargin{:});

% Pass through parsed inputs to cornermetric. Only specify
% SensitivityFactor if Harris is the method. We've already verified in
% parseInputs that the user did not specify SensitivityFactor with a method
% other than Harris.
if strcmpi(method,'Harris');
    cMetric = cornermetric(I,...
        'Method',method,...
        'SensitivityFactor',sensitivity_factor,...
        'FilterCoefficients',filter_coef);
else
    cMetric = cornermetric(I,...
        'Method',method,...
        'FilterCoefficients',filter_coef);
end

% Use findpeak to do peak detection on output of cornermetric to find x/y
% locations of peaks.
[xpeak, ypeak] = findLocalPeak(cMetric,quality_level);

% Create vector of interest points from x/y peak locations.
corners = [xpeak, ypeak];

% Return N corners as specified by maxNumCorners optional input argument.
if max_corners < size(corners,1)
    corners = corners(1:max_corners,:); 
end

varargout{1} = corners;

%------------------------------------------------------------------
function BW = suppressLowCornerMetricMaxima(cMetric,BW,quality_level)

max_cmetric = max(cMetric(:));
if max_cmetric > 0
    min_metric = quality_level * max_cmetric;
else
    % Edge case: All corner metric values are 0 or less than zero. In this
    % case, mask all local maxima and return. This case arrises for uniform
    % input images.
    BW(:) = false;
    return
end

% Mask peak locations that are less than min_metric.
BW(cMetric < min_metric) = false;

%-------------------------------------------------------------------------
function [xpeak,ypeak] = findLocalPeak(cMetric,quality_level)

% The cornermetric matrix is all equal values for all input
% images with numRows/numCols <= 3. We require at least 4 rows
% and 4 colums to return a non-empty corner array.
[numRows,numCols] = size(cMetric);
if  ( (numRows < 4) || (numCols < 4))
    xpeak  = [];
    ypeak = [];
    return
end

% Find local maxima of corner metric matrix.
BW = imregionalmax(cMetric,8);

BW = suppressLowCornerMetricMaxima(cMetric,BW,quality_level);

% Suppress connected components which have same intensity and are part of
% one local maxima grouping. We want to 'thin' these local maxima to a
% single point using bwmorph.
BW = bwmorph(BW,'shrink',Inf);

% Return r/c locations that are valid non-thresholded corners. Return
% corners in order of decreasing corner metric value.
[r,c] = sortCornersByCornerMetric(BW,cMetric);

xpeak = c;
ypeak = r;

%-------------------------------------------------------------------------
function [r,c] = sortCornersByCornerMetric(BW,cMetric)

ind = find(BW);
[~,sorted_ind] = sort(cMetric(ind),'descend');
[r,c] = ind2sub(size(BW),ind(sorted_ind));

%-------------------------------------------------------------------------
function [I,method,sensitivity_factor,filter_coef,...
                  max_corners, quality_level] = parseInputs(varargin)
    
   % Reform varargin into consistent ordering: corner(I,METHOD,N) so that
   % we can use inputParser to do input parsing on optional args and P/V
   % pairs.
   if (nargin>1 && isnumeric(varargin{2}))
       if nargin>2
           %corner(I,N,P1,V1,...)
           varargin(4 : (nargin+1) ) = varargin(3:nargin);
       end
       
       %Now that any P/V have been handled, reorder 2nd and 3rd arguments
       %into the form:
       %corner(I,METHOD,N,...)
      varargin{3} = varargin{2};
      varargin{2} = 'Harris';
      
   end
       
parser = commonCornerInputParser(mfilename);
parser.addOptional('N',200,@checkMaxCorners);
parser.addParamValue('QualityLevel',0.01,@checkQualityLevel);

% parse input
parser.parse(varargin{:});

% assign outputs
I = parser.Results.Image;
method = parser.Results.Method;
sensitivity_factor = parser.Results.SensitivityFactor;
filter_coef = parser.Results.FilterCoefficients;
max_corners = parser.Results.N;
quality_level = parser.Results.QualityLevel;

% check for incompatible parameters.  if user has specified a sensitivity
% factor with method other than harris, we error.  We made the sensitivity
% factor default value a string to determine if one was specified or if the
% default was provided since we cannot get this information from the input
% parser object.
method_is_not_harris = ~strcmpi(method,'Harris');
sensitivity_factor_specified = ~ischar(sensitivity_factor);
if method_is_not_harris && sensitivity_factor_specified
    eid = sprintf('Images:%s:invalidParameterCombination',mfilename);
    error(eid,'%s',['The ''SensitivityFactor'' parameter is only '...
        'valid with the ''Harris'' method.']);
end

% convert from default strings to actual values.
if ischar(sensitivity_factor)
    sensitivity_factor = str2double(sensitivity_factor);
end

%-------------------------------
function tf = checkMaxCorners(x)
        
validateattributes(x,{'numeric'},{'nonempty','nonnan','real',...
            'scalar','integer','positive','nonzero'},mfilename,'N');
tf = true;

%-------------------------------
function tf = checkQualityLevel(x)
        
validateattributes(x,{'numeric'},{'nonempty','nonnan','real',...
            'scalar'},mfilename,'QualityLevel');
        
% The valid range is (0,1).        
if (x >=1) || (x <=0)
    error('Images:corner:invalidQualityLevel','The ''QualityLevel'' parameter must be in the range (0,1).');
end

tf = true;
