function [C, Rc, Tc] = read_calibration(imagenumber)

%% Loading matrices
IMAGES_PER_CALIB_FILE = 8;

% Calculating file to load
calibFileNumber = floor(imagenumber/IMAGES_PER_CALIB_FILE);
calibFileBase = '../data/calib/camera';
calibFile = strcat(calibFileBase, num2str(calibFileNumber));

% Loading from calibration file
run(calibFile);

%% Loading intrinsic parameters
C = [fc(1), alpha_c*fc(1), cc(1)
     0,     fc(2),         cc(2)
     0,     0,             1];

%% Loading extrinsic parameters
rotationBase = 'omc_';
translationBase = 'Tc_';

Rc = rodrigues(eval(strcat(rotationBase, num2str(imagenumber))));
Tc = eval(strcat(translationBase, num2str(imagenumber)));

end