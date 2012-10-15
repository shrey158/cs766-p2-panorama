% radial distortion removal
% By Qinyuan Sun 10/15/2012

% load camera calibration parameters
% Canon A640, tag 4726208885 for resolution 480x640
f0 = 663.3665;
k1 = -0.19447;
k2 = 0.233821;
% image we are taking has resolution 2736x3648
mul = 2736/480;
f = f0*mul;
% read distorted images
distortedImg = imread('set2\IMG_3799.jpg');
[numCols,numRows,~] = size(distortedImg);
% our images are taken in portrait
if numCols < numRows
    distortedImg = imrotate(distortedImg,-90);
end
% figure(1),imshow(distortedImg);
% title('distorted image')
% create the coordinate matrix
[Xp,Yp] = meshgrid(1:numRows,1:numCols);
% we get x' y' from distorted image, untranslate to image center
xoffset = floor(numCols);
yoffset = floor(numRows);
Xo = xoffset*ones(size(Xp));
Yo = yoffset*ones(size(Yp));
Xd = Xp/f - Xo/f;
% according to the parameters, get undistorted normalized coordinates

% translate to the desired cooridinate


