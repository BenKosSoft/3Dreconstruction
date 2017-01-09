% Intrinsic and Extrinsic Camera Parameters
%
% This script file can be directly executed under Matlab to recover the camera intrinsic and extrinsic parameters.
% IMPORTANT: This file contains neither the structure of the calibration objects nor the image coordinates of the calibration points.
%            All those complementary variables are saved in the complete matlab data file Calib_Results.mat.
% For more information regarding the calibration model visit http://www.vision.caltech.edu/bouguetj/calib_doc/


%-- Focal length:
fc = [ 876.440082178467720 ; 877.263162000075230 ];

%-- Principal point:
cc = [ 384.010672090634900 ; 371.844791639205370 ];

%-- Skew coefficient:
alpha_c = 0.000000000000000;

%-- Distortion coefficients:
kc = [ 0.037073463526004 ; 0.155920745466283 ; -0.003605374636161 ; 0.002313206412233 ; 0.000000000000000 ];

%-- Focal length uncertainty:
fc_error = [ 2.775586200717262 ; 2.888363878316011 ];

%-- Principal point uncertainty:
cc_error = [ 2.435796267175053 ; 2.340923595674197 ];

%-- Skew coefficient uncertainty:
alpha_c_error = 0.000000000000000;

%-- Distortion coefficients uncertainty:
kc_error = [ 0.010928519611134 ; 0.067248913677673 ; 0.000989317137182 ; 0.001202562476990 ; 0.000000000000000 ];

%-- Image size:
nx = 756;
ny = 756;


%-- Various other variables (may be ignored if you do not use the Matlab Calibration Toolbox):
%-- Those variables are used to control which intrinsic parameters should be optimized

n_ima = 20;						% Number of calibration images
est_fc = [ 1 ; 1 ];					% Estimation indicator of the two focal variables
est_aspect_ratio = 1;				% Estimation indicator of the aspect ratio fc(2)/fc(1)
center_optim = 1;					% Estimation indicator of the principal point
est_alpha = 0;						% Estimation indicator of the skew coefficient
est_dist = [ 1 ; 1 ; 1 ; 1 ; 0 ];	% Estimation indicator of the distortion coefficients


%-- Extrinsic parameters:
%-- The rotation (omc_kk) and the translation (Tc_kk) vectors for every calibration image and their uncertainties

%-- Image #1:
omc_1 = [ 1.764946e+00 ; -2.495328e+00 ; 5.048723e-01 ];
Tc_1  = [ 1.194933e+02 ; 5.277523e+01 ; 4.922470e+02 ];
omc_error_1 = [ 1.802793e-03 ; 3.346785e-03 ; 5.604608e-03 ];
Tc_error_1  = [ 1.375797e+00 ; 1.329247e+00 ; 1.621660e+00 ];

%-- Image #2:
omc_2 = [ 1.984771e+00 ; -2.197948e+00 ; 2.164265e-01 ];
Tc_2  = [ 1.757758e+01 ; 7.937270e+01 ; 4.493424e+02 ];
omc_error_2 = [ 2.712073e-03 ; 2.754022e-03 ; 5.807310e-03 ];
Tc_error_2  = [ 1.262002e+00 ; 1.215580e+00 ; 1.544261e+00 ];

%-- Image #3:
omc_3 = [ 1.756874e+00 ; -2.075601e+00 ; 5.968612e-01 ];
Tc_3  = [ 5.938739e+01 ; 1.203093e+00 ; 3.600815e+02 ];
omc_error_3 = [ 1.862178e-03 ; 2.812552e-03 ; 4.145170e-03 ];
Tc_error_3  = [ 1.001519e+00 ; 9.642621e-01 ; 1.206728e+00 ];

%-- Image #4:
omc_4 = [ 2.010707e+00 ; -2.136536e+00 ; 5.251101e-01 ];
Tc_4  = [ 7.417775e+01 ; 8.570691e+01 ; 3.875498e+02 ];
omc_error_4 = [ 1.997460e-03 ; 2.635406e-03 ; 4.786395e-03 ];
Tc_error_4  = [ 1.091154e+00 ; 1.056940e+00 ; 1.259844e+00 ];

%-- Image #5:
omc_5 = [ -1.952193e+00 ; 2.038180e+00 ; -7.316096e-02 ];
Tc_5  = [ 8.165818e+01 ; 1.324233e+02 ; 4.964747e+02 ];
omc_error_5 = [ 2.481597e-03 ; 2.662280e-03 ; 5.011925e-03 ];
Tc_error_5  = [ 1.410019e+00 ; 1.313296e+00 ; 1.459034e+00 ];

%-- Image #6:
omc_6 = [ 1.395005e-01 ; 2.919233e+00 ; -6.568493e-01 ];
Tc_6  = [ 1.017339e+02 ; -1.047724e+02 ; 4.529216e+02 ];
omc_error_6 = [ 1.182789e-03 ; 3.210853e-03 ; 4.424053e-03 ];
Tc_error_6  = [ 1.275152e+00 ; 1.208525e+00 ; 1.431660e+00 ];

%-- Image #7:
omc_7 = [ 1.357576e-01 ; 2.853236e+00 ; -8.661113e-01 ];
Tc_7  = [ 8.632041e+01 ; -1.020854e+02 ; 4.299896e+02 ];
omc_error_7 = [ 1.419272e-03 ; 3.108005e-03 ; 4.142800e-03 ];
Tc_error_7  = [ 1.212393e+00 ; 1.148054e+00 ; 1.297878e+00 ];

%-- Image #8:
omc_8 = [ -4.176888e-01 ; -2.735665e+00 ; -6.732173e-01 ];
Tc_8  = [ 6.523147e+01 ; -6.852414e+01 ; 3.206579e+02 ];
omc_error_8 = [ 1.082195e-03 ; 3.137178e-03 ; 4.310795e-03 ];
Tc_error_8  = [ 8.999994e-01 ; 8.649095e-01 ; 1.261670e+00 ];

%-- Image #9:
omc_9 = [ 2.648910e+00 ; -8.714902e-02 ; 1.958436e-02 ];
Tc_9  = [ -1.161912e+02 ; 4.416623e+01 ; 3.804259e+02 ];
omc_error_9 = [ 3.020453e-03 ; 1.203148e-03 ; 4.189742e-03 ];
Tc_error_9  = [ 1.063627e+00 ; 1.040059e+00 ; 1.242473e+00 ];

%-- Image #10:
omc_10 = [ 3.013710e+00 ; 4.750626e-02 ; 1.284946e-01 ];
Tc_10  = [ -9.221938e+01 ; 5.617064e+01 ; 4.436039e+02 ];
omc_error_10 = [ 4.177942e-03 ; 8.400530e-04 ; 6.096883e-03 ];
Tc_error_10  = [ 1.246497e+00 ; 1.202512e+00 ; 1.500593e+00 ];

%-- Image #11:
omc_11 = [ 1.902510e+00 ; 1.841461e+00 ; -3.153340e-01 ];
Tc_11  = [ -7.428782e+01 ; -1.258217e+02 ; 4.140194e+02 ];
omc_error_11 = [ 2.083776e-03 ; 2.451579e-03 ; 3.905408e-03 ];
Tc_error_11  = [ 1.172688e+00 ; 1.098538e+00 ; 1.317146e+00 ];

%-- Image #12:
omc_12 = [ 2.083432e+00 ; 1.230423e+00 ; -1.784701e-01 ];
Tc_12  = [ -1.161598e+02 ; -9.718094e+01 ; 3.920486e+02 ];
omc_error_12 = [ 2.537430e-03 ; 2.112256e-03 ; 3.483404e-03 ];
Tc_error_12  = [ 1.109047e+00 ; 1.047891e+00 ; 1.275205e+00 ];

%-- Image #13:
omc_13 = [ 2.292662e+00 ; -1.231452e+00 ; 4.312756e-01 ];
Tc_13  = [ -1.437927e+00 ; 2.323916e+01 ; 4.058269e+02 ];
omc_error_13 = [ 2.667735e-03 ; 2.187049e-03 ; 4.066726e-03 ];
Tc_error_13  = [ 1.122788e+00 ; 1.093223e+00 ; 1.385194e+00 ];

%-- Image #14:
omc_14 = [ 2.334756e+00 ; -1.632470e+00 ; 4.923741e-01 ];
Tc_14  = [ 3.487163e+01 ; 1.045809e+02 ; 5.716431e+02 ];
omc_error_14 = [ 3.185813e-03 ; 2.599459e-03 ; 5.591697e-03 ];
Tc_error_14  = [ 1.600782e+00 ; 1.553085e+00 ; 1.966286e+00 ];

%-- Image #15:
omc_15 = [ 9.744297e-01 ; 2.404239e+00 ; -9.135492e-01 ];
Tc_15  = [ 4.302010e+01 ; -1.283333e+02 ; 4.738441e+02 ];
omc_error_15 = [ 1.437532e-03 ; 3.145069e-03 ; 3.754426e-03 ];
Tc_error_15  = [ 1.338955e+00 ; 1.274781e+00 ; 1.334599e+00 ];

%-- Image #16:
omc_16 = [ 1.275391e+00 ; 2.554271e+00 ; -6.065979e-01 ];
Tc_16  = [ 1.805253e+01 ; -1.275322e+02 ; 5.424772e+02 ];
omc_error_16 = [ 1.368580e-03 ; 3.237949e-03 ; 4.788113e-03 ];
Tc_error_16  = [ 1.518968e+00 ; 1.442399e+00 ; 1.691676e+00 ];

%-- Image #17:
omc_17 = [ -3.082750e-02 ; 3.108753e+00 ; -1.150700e-01 ];
Tc_17  = [ 1.077023e+02 ; -7.889510e+01 ; 3.520090e+02 ];
omc_error_17 = [ 6.067937e-04 ; 3.168724e-03 ; 4.851352e-03 ];
Tc_error_17  = [ 9.922689e-01 ; 9.448011e-01 ; 1.188204e+00 ];

%-- Image #18:
omc_18 = [ 1.472188e-01 ; 2.985920e+00 ; -8.397683e-01 ];
Tc_18  = [ 9.433478e+01 ; -1.298231e+02 ; 4.235815e+02 ];
omc_error_18 = [ 1.473764e-03 ; 3.118315e-03 ; 4.418713e-03 ];
Tc_error_18  = [ 1.204068e+00 ; 1.131087e+00 ; 1.345504e+00 ];

%-- Image #19:
omc_19 = [ 2.824067e+00 ; -1.032119e-01 ; 4.560874e-02 ];
Tc_19  = [ -8.583908e+01 ; 9.775957e+01 ; 3.820581e+02 ];
omc_error_19 = [ 3.429168e-03 ; 8.355158e-04 ; 4.746369e-03 ];
Tc_error_19  = [ 1.087267e+00 ; 1.055716e+00 ; 1.232255e+00 ];

%-- Image #20:
omc_20 = [ 3.000479e+00 ; 5.419512e-01 ; 3.031280e-01 ];
Tc_20  = [ -1.140498e+02 ; -1.988434e+01 ; 5.669667e+02 ];
omc_error_20 = [ 4.863640e-03 ; 1.510248e-03 ; 7.520930e-03 ];
Tc_error_20  = [ 1.591640e+00 ; 1.530174e+00 ; 2.000542e+00 ];

