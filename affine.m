% imgBuff = affine(panoImgBuff, drift)
% input:
%   panoImgBuff - the img buff to be drifted back
%   drift - the number of pixels in vertical direction that the picture
%   drifted. Assume there is a scene point at pixel (r_i, c_i) in the left
%   area of the image, and the scene point is also included in another
%   pixel (r_j, c_j) in the right area of the image. The drift is
%   calculated as drift = r_j - r_i.
%
% output:
%   imgBuff - the affined image buffer object with drift removal
%
% function description:
% This function takes an image object and applies an affine transformation
% to remove the vertical drift of the image.

function imgBuff = affine(panoImgBuff, drift)
    [nRows, nCols, nChnls] = size(panoImgBuff);
    imgBuff = zeros(nRows, nCols, nChnls);
    for ri = 1:nRows
        for ci = 1:nCols
            ri_new = ceil(ri+ci/nCols*drift);
            for chnl = 1:nChnls
                if ri_new > 0 && ri_new <= nRows
                    imgBuff(ri_new, ci, chnl) = panoImgBuff(ri,ci,chnl);
                end
            end
        end
    end
    imgBuff = uint8(imgBuff);
end

