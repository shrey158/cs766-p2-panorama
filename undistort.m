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

% construct a rotation matrix. Identity matrix if no need to rotate
if rt_flag == 1
    sourceImg = imrotate(inImgBuff,-90);
else
    sourceImg = inImgBuff;
end

% initialize the output image buffer
[nRows,nCols,nChnls] = size(sourceImg);
outImgBuff = zeros(nRows,nCols,nChnls,'double');

% inverse warping
% Find/Generate the depth values for each pixel in the output image by
% looking up the corresponding scene point in the input image.
for r = 1:nRows
    for c = 1:nCols
        [rc_row, rc_col] = findUndistortPts(r,c,f,k1,k2,[nRows,nCols]);
        [depths, flag] = interpolateDepths(sourceImg,rc_row,rc_col);
        outImgBuff(r,c,:) = [depths,flag];
    end
end

% reformat the image buffer
if rt_flag == 1
    outImgBuff = uint8(imrotate(outImgBuff,90));
else
    outImgBuff = uint8(outImgBuff);
end
end

function [dr, dc] = findUndistortPts(r,c,f,k1,k2,imgSize)
% find out corresponding coordinates according to inverse warping
% sz = [nRows,nCols] is the size of the image.
nRows = imgSize(1);
nCols = imgSize(2);
offsets_x = round(nCols/2);
offsets_y = round(nRows/2);
% convert origin to image center
rn_col = (c-offsets_x)/f;
rn_row = (nRows-r+1-offsets_y)/f;
% apply radial distortion
r2 = rn_col*rn_col + rn_row*rn_row;
d = (1+k1*r2+k2*r2*r2);
rd_col = rn_col*d;
rd_row = rn_row*d;
% convert origin to image left-top
dc = f*rd_col + offsets_x;
dr = nRows - (f*rd_row + offsets_y);
end