% img = affine(panoImg, drift)
% input:
%   panoImg - the img to be drifted back
%   drift - the number of pixels in vertical direction that the picture
%   drifted. Assume there is a scene point at pixel (r_i, c_i) in the left
%   area of the image, and the scene point is also included in another
%   pixel (r_j, c_j) in the right area of the image. The drift is
%   calculated as drift = r_j - r_i.
%
% output:
%   img - the affined image object with drift removal
%
% function description:
% This function takes an image object and applies an affine transformation
% to remove the vertical drift of the image.

function img = affine(panoImg, drift)
    nrows = size(panoImg,1);
    ncols = size(panoImg,2);
    nclrs = size(panoImg,3);
    img = zeros(nrows, ncols, nclrs);
    for ri = 1:nrows
        for ci = 1:ncols
            for clri = 1:nclrs
                ri_new = ceil(ri+ci/ncols*drift);
                if ri_new > 0 && ri_new <= ncols
                    img(ri_new, ci, clri) = panoImg(ri,ci,clri);
                end
            end
        end
    end
    img = uint8(img);
end

