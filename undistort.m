% outImgBuff = undistort(inImgBuff,f,k1,k2,rt_flag)
% input
%   inImgBuff - the input image buffer to be undistorted
%   f - the focal length
%   k1, k2 - the distortion factors
%   rt_flag - indication of whether the image needs to be rotated to match
%   the calibration set up of k1 and k2
% output
%   outImgBuff - the undistorted image buffer

function outImgBuff = undistort(inImgBuff,f,k1,k2,rt_flag)

% initialize the output image buffer
[nRows,nCols,nChnls] = size(inImgBuff);
outImgBuff = zeros(nRows,nCols,nChnls);

% construct a rotation matrix. Identity matrix if no need to rotate
rt = [1,0;0,1];
if rt_flag == 1
    rt = [0,1;-1,0];
end

% construct the transformation matrices between [x,y] coordinates and [r,c]
% indices. [r, c] are row and column numbers starting from 1. [x, y]
% originates from the center point of the image. x increases along the
% right direction and y increases along the up direction.
rc2xy = [0,-1;1,0;-round(nCols/2),round(nRows/2)];
xy2rc = [0,1;-1,0;round(nRows/2),round(nCols/2)];

% inverse warping
% Find/Generate the depth values for each pixel in the output image by
% looking up the corresponding scene point in the input image.
for r = 1:nRows
    for c = 1:nCols
        xy = [r,c,1]*rc2xy*rt;
        xy_n = xy/f;
        r2 = xy_n*xy_n';
        rd = (1+k1*r2+k2*r2^2); % radial distortion
        xy_d = xy_n*rd;
        xy_dist = xy_d*f*rt';
        rc_d = [xy_dist,1]*xy2rc;
        [depths, flag] = interpolateDepths(inImgBuff,rc_d(1),rc_d(2));
        outImgBuff(r,c,:) = [depths,flag];
    end
end

% reformat the image buffer
outImgBuff = uint8(outImgBuff);
end