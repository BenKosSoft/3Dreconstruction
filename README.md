# **3D Object Reconstruction Using 2 Stereo Images**

MATLAB implementation for 3D Object reconstruction, including example input and outputs

**Implemented by:**

* @mbenlioglu
* @mertkosan

## About

In this project the focus was to estimate the 3D locations of objects using two stereo images. 

3D reconstruction has always been a challenging achievement. Using 3D reconstruction, we can extract
objects’ 3D profile, also learn the 3D coordinates of any points. Therefore, 3D construction can be
used in various areas of interest such as, geometrical analysis and design, industrial applications,
computer graphics etc.
Since the computer vison is a reverse problem, in which we try to recover the lost data (i.e. the
depth information) during the projection of 3D world to a 2D plane, 3D reconstruction of points using
triangulation and recovering the depth information is one of the key aspects of the computer vision.

This project tries to address this key concept and tried to recover the lost dimension by using the
corresponding features in pair of stereo images with a calibrated camera.

#### _System architecture followed for the project:_
![System Architecture Img](/docs/img/SysArch.png)

For further information refer to [final report of the project](/docs/report/FinalReport.pdf)

## Getting Started
There are two parts to this project: _Calibration Step_ & _Object Reconstruction Step_

_**1. Calibration Step:**_

In this step the camera that will be used for the experiment should be calibrated (to accurately
remove camera distortion) by using a calibration rig by taking ~15-20 images of this rig from 
different angles.
	
Input images from the camera that will be used in experiment can be provided by changing the **lines 11-24**
in  _"CalibrateCamera.m"_, which are:
```matlab
imageFileNames = {'CalibrationImages/2/20170110_233339.jpg',...
    'CalibrationImages/2/20170110_233343.jpg',...
    'CalibrationImages/2/20170110_233347.jpg',...
    'CalibrationImages/2/20170110_233350.jpg',...
    'CalibrationImages/2/20170110_233352.jpg',...
    'CalibrationImages/2/20170110_233409.jpg',...
    'CalibrationImages/2/20170110_233411.jpg',...
    'CalibrationImages/2/20170110_233412.jpg',...
    'CalibrationImages/2/20170110_233415.jpg',...
    'CalibrationImages/2/20170110_233416.jpg',...
    'CalibrationImages/2/20170110_233418.jpg',...
    'CalibrationImages/2/20170110_233422.jpg',...
    'CalibrationImages/2/20170110_233424.jpg',...
    };
```
Provided lines of code takes images provided in this repository which are calibration images used
to create this project.

Furthermore, square size of the calibration rig at the **line 31** of _"CalibrateCamera.m"_ should
also be updated, which is:
```matlab
squareSize = 10;  % in units of 'mm'
```
Running the script after these adjustments should successfully calibrate your camera.
    
_**2. Object Reconstruction Step:**_
	
* In this step _"ObjectReconstruction.m"_ uses two stereo images and camera calibration results to
create the reconstructed environment. 
Each stereo image set should be under their own folder and this folder is provided to the code.
A different set can be provided by changing the path provided in **line 14**. Example stereo images
are under _"./StereoImages/"_
```matlab
imageDir = fullfile('StereoImages','3'); % 3 examples provided, replace 1 with
                                         % 2 or 3 for others
```	
* Camera calibration results are by default loaded from _"./calibrationResults.mat"_. You can provide
your calibration results either by saving your results under this name or modifying the **line 27** of
the code
```matlab
% Load precomputed intrinsic camera parameters using the Camera calibrator
% app (code for it is in CalibrateCamera.m)
load calibrationResults.mat
```
After making needed changes code should reconstruct the environment from the provided stereo images.
Example outputs can be found under _"./OutputImages/"_
 