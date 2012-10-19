% imgBuff = crop(panoImgBuff, r1, c1, r2, c2)
% input:
%   panoImgBuff - the img buffer to be cropped
%   r1 - the row index of the upper cropping line
%   c1 - the column index of the left cropping line
%   r2 - the row index of the bottom cropping line
%   c2 - the column index of the right cropping line
% output:
%   imgBuff - the cropped image buffer object
%
% function description:
% This function takes an image object and cropped it with the given
% cropping lines presented in the form of row/column indices.

function imgBuff = crop(panoImgBuff, r1, c1, r2, c2)
    imgBuff = panoImgBuff(r1:r2,c1:c2,:);
end