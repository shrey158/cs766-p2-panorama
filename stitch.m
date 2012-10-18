function [img, delT] = stitch(img1, img2, T)
    rt = T(1);
    ct = T(2);
    max_ri = ceil(max([size(img1,1),size(img2,1)+rt]));
    max_ci = ceil(max([size(img1,2),size(img2,2)+ct]));
    min_ri = floor(min([1, 1+rt]));
    min_ci = floor(min([1, 1+ct]));
    delT = [min_ri-1,min_ci-1];
    nr = max_ri - min_ri + 1;
    nc = max_ci - min_ci + 1;
    img = zeros(nr, nc, size(img1,3));
    
    % copy the first image into the new image canvas
    for r = 1:size(img1,1)
        for c = 1:size(img1,2)
            for clr = 1:size(img1,3)
                img(r-min_ri+1,c-min_ci+1,clr) = img1(r,c,clr);
            end
        end
    end
    
    % copy the second image onto the new image canvas, probably
    % overwriting some part of the first image without blending.
    for r = 1:size(img2,1)
        for c = 1:size(img2,2)
            for clr = 1:size(img2,3)
                rNew = ceil(r+rt-min_ri+1);
                cNew = ceil(c+ct-min_ci+1);
                if img2(r,c,clr)~=0
                    img(rNew, cNew, clr) = img2(r,c,clr);
                end
            end
        end
    end
    
    img = uint8(img);
end