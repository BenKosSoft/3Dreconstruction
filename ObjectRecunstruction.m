%% Info
%{
owners: mertkosan (Mert Kosan), mbenlioglu(Muhammed Mucahid Benlioglu)
created date: 10.01.2017

3D reconstruction of points from 2 views
%}

%% Read a Pair of Images
% Load a pair of images into the workspace.

clear all;close all;

imageDir = fullfile('StereoImages','3'); % 3 examples provided, replace 1 with
                                         % 2 or 3 for others
images = imageSet(imageDir);
I1 = read(images, 1);
I2 = read(images, 2);
figure
imshowpair(I1, I2, 'montage'); 
title('Original Images');

%% Load Camera Parameters 

% Load precomputed intrinsic camera parameters using the Camera calibrator
% app (code for it is in CalibrateCamera.m)
load calibrationResults.mat

%% Remove Lens Distortion
% To improve the accuracy of the final reconstruction, we should remove the
% distortion from each of the images using the undistortImage function
% provided by the computer vision toolbox.

I1 = undistortImage(I1, cameraParams);
I2 = undistortImage(I2, cameraParams);

figure 
imshowpair(I1, I2, 'montage');
title('Undistorted Images');

% black parts at the edge severely affect the results... Therefore it
% should be cropped to get rid of them, coordinates are measured statically
% from one pair, but it seems to fit every pair obtained from the same
% camera

I1 = imcrop(I1,[85 63 1900 1407]);
I2 = imcrop(I2,[85 63 1900 1407]);

figure 
imshowpair(I1, I2, 'montage');
title('Undistorted Images after cropping black parts');
%% Find Point Correspondences Between The Images
% Detect good features to track using Shi-Tomasi feautres. Then we find the
% correspondig points between two images using Kanade-Lucas-Tomasi
% algorithm

% Detect feature points (Shi-Tomasi corners)
imagePoints1 = detectMinEigenFeatures(rgb2gray(I1), 'MinQuality', 0.1);

% Visualize detected points
figure
imshow(I1, 'InitialMagnification', 50);
title('150 Strongest Corners from the First Image');
hold on
plot(selectStrongest(imagePoints1, 150));

% Create the point tracker
% NumPyramidLevels: in this function KLT algorithm uses image pyramids,
% where each level is reduced in resolution by factor of 2 compared to
% previous level. This allows the algorithm to handle larger displacements
% of points between frames.
% MaxBidirectionalError: Track the point from previous frame to next then
% next to previous calculate the error between actual point and calculated
% one.
tracker = vision.PointTracker('MaxBidirectionalError', 1, 'NumPyramidLevels', 5);

% Initialize the point tracker
imagePoints1 = imagePoints1.Location;
initialize(tracker, imagePoints1, I1);

% Track the points
[imagePoints2, validIdx] = step(tracker, I2);
matchedPoints1 = imagePoints1(validIdx, :);
matchedPoints2 = imagePoints2(validIdx, :);

% Visualize correspondences
figure
showMatchedFeatures(I1, I2, matchedPoints1, matchedPoints2);
title('Tracked Features');


%% Estimate the Fundamental Matrix
% Caluclate fundemental matrix and find the inlier points that meet the
% epipolar constraint using the estimateFundamentalMatrix function

% Estimate the fundamental matrix
[fMatrix, epipolarInliers] = estimateFundamentalMatrix(...
  matchedPoints1, matchedPoints2, 'Method', 'MSAC', 'NumTrials', 10000);

% Find epipolar inliers
inlierPoints1 = matchedPoints1(epipolarInliers, :);
inlierPoints2 = matchedPoints2(epipolarInliers, :);

% Display inlier matches
figure
showMatchedFeatures(I1, I2, inlierPoints1, inlierPoints2);
title('Epipolar Inliers');

%% Compute the Camera Pose
% Compute the rotation and translation between the camera poses
% corresponding to the two images. Note that |t| is a unit vector,
% because translation can only be computed up to scale.

[R, t] = cameraPose(fMatrix, cameraParams, inlierPoints1, inlierPoints2);

%% Reconstruct the 3-D Locations of Matched Points
% Re-detect points in the first image using lower |'MinQuality'| to get
% more points. Track the new points into the second image. Estimate the 
% 3-D locations corresponding to the matched points using the |triangulate|
% function, which implements the Direct Linear Transformation
% (DLT) algorithm. Place the origin at the optical center of the camera
% corresponding to the first image.

% Detect dense feature points
imagePoints1 = detectMinEigenFeatures(rgb2gray(I1), 'MinQuality', 0.001);

% Create the point tracker
tracker = vision.PointTracker('MaxBidirectionalError', 1, 'NumPyramidLevels', 5);

% Initialize the point tracker
imagePoints1 = imagePoints1.Location;
initialize(tracker, imagePoints1, I1);

% Track the points
[imagePoints2, validIdx] = step(tracker, I2);
matchedPoints1 = imagePoints1(validIdx, :);
matchedPoints2 = imagePoints2(validIdx, :);

% Compute the camera matrices for each position of the camera
% The first camera is at the origin looking along the X-axis. Thus, its
% rotation matrix is identity, and its translation vector is 0.
camMatrix1 = cameraMatrix(cameraParams, eye(3), [0 0 0]);
camMatrix2 = cameraMatrix(cameraParams, R', -t*R');

% Compute the 3-D points (direct linear transformation)
points3D = triangulate(matchedPoints1, matchedPoints2, camMatrix1, camMatrix2);

% Get the color of each reconstructed point
numPixels = size(I1, 1) * size(I1, 2);
allColors = reshape(I1, [numPixels, 3]);
colorIdx = sub2ind([size(I1, 1), size(I1, 2)], round(matchedPoints1(:,2)), ...
    round(matchedPoints1(:, 1)));
color = allColors(colorIdx, :);

% Create the point cloud
ptCloud = pointCloud(points3D, 'Color', color);

%% Display the 3-D Point Cloud
% Use the |plotCamera| function to visualize the locations and orientations
% of the camera, and the |pcshow| function to visualize the point cloud.

% Visualize the camera locations and orientations
cameraSize = 0.3;
figure
plotCamera('Size', cameraSize, 'Color', 'r', 'Label', '1', 'Opacity', 0);
hold on
grid on
plotCamera('Location', t, 'Orientation', R, 'Size', cameraSize, ...
    'Color', 'b', 'Label', '2', 'Opacity', 0);

% Visualize the point cloud
pcshow(ptCloud, 'VerticalAxis', 'y', 'VerticalAxisDir', 'down', ...
    'MarkerSize', 45);

% Rotate and zoom the plot
camorbit(0, -30);
camzoom(1.5);

% Label the axes
xlabel('x-axis');
ylabel('y-axis');
zlabel('z-axis')

title('Up to Scale Reconstruction of the Scene');

%% Fit a Sphere to the Point Cloud to Find the Globe
% In examples 1 and 2 we know there is a globe (earth) therefore in order
% to better visulize the 3D shape we are plotting the best fitting globe by
% using pcfitsphere function, which is again provided by computer vision
% toolbox. Note: 3rd example does not contain any globe features, therefore
% resulting globe is irrelevant in that example...

% Detect the globe
globe = pcfitsphere(ptCloud, 0.1);

% Display the surface of the globe
plot(globe);
title('Estimated Location and Size of the Globe');
hold off

%% Metric Reconstruction of the Scene
% The actual radius of the globe is 5cm. We can now determine the
% coordinates of the 3-D points in centimeters.

% Determine the scale factor
scaleFactor = 5 / globe.Radius;

% Scale the point cloud
ptCloud = pointCloud(points3D * scaleFactor, 'Color', color);
t = t * scaleFactor;

% Visualize the point cloud in centimeters
cameraSize = 2; 
figure
plotCamera('Size', cameraSize, 'Color', 'r', 'Label', '1', 'Opacity', 0);
hold on
grid on
plotCamera('Location', t, 'Orientation', R, 'Size', cameraSize, ...
    'Color', 'b', 'Label', '2', 'Opacity', 0);

% Visualize the point cloud
pcshow(ptCloud, 'VerticalAxis', 'y', 'VerticalAxisDir', 'down', ...
    'MarkerSize', 45);
camorbit(0, -30);
camzoom(1.5);

% Label the axes
xlabel('x-axis (cm)');
ylabel('y-axis (cm)');
zlabel('z-axis (cm)')
title('Metric Reconstruction of the Scene');