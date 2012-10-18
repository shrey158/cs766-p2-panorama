function [img, delT] = stitch(img1, img2, T)
% img1 and img2 are the images to stitch together, T is the translation
% from image 2 to image 1



[img1_rows,img1_cols,numClr] = size(img1);
[img2_rows,img2_cols,~] = size(img2);
rt = round(T(1)); % row translation
ct = round(T(2)); % colum translation

%create a new image to contain two old images
max_ri = ceil(max([img1_rows,img2_rows+rt]));
max_ci = ceil(max([img1_cols,img2_cols+ct]));
min_ri = floor(min([1, 1+rt]));
min_ci = floor(min([1, 1+ct]));
% define image boundary
delT = [min_ri-1,min_ci-1];
nr = max_ri - min_ri + 1;
nc = max_ci - min_ci + 1;
% initialize the image 
img = uint8(zeros(nr, nc, numClr));

% create mask
img1_grr = [1:img1_rows]-min_ri+1; % img1 global row range
img1_gcr = [1:img1_cols]-min_ci+1; % img1 global col range
img2_grr = [1:img2_rows]+rt-min_ri+1;
img2_gcr = [1:img2_cols]+ct-min_ci+1;
[~, ia, ib] = intersect(img1_gcr,img2_gcr);
mask1 = ones(1,img1_cols);
mask2 = ones(1,img2_cols);
if(ia(1) == 1)
    mask1(ia) = (ia-1)/(numel(ia)-1);
else
    mask1(ia) = (ia(end:-1:1)-ia(1))/(numel(ia)-1);
end
mask1 = repmat(mask1,[img1_rows,1,3]);
if(ib(1) == 1)
    mask2(ib) = (ib-1)/(numel(ib)-1);
else
    mask2(ib) = (ib(end:-1:1)-ib(1))/(numel(ib)-1);
end
mask2 = repmat(mask2,[img2_rows,1,3]);
img(img1_grr,img1_gcr,:) = double(img1).*mask1;
img(img2_grr,img2_gcr,:) = max(double(img(img2_grr,img2_gcr,:)),...
    double(img2).*mask2);

% % fill in the non-overlapped part
% % for image 1
% % if ct >= 0
% %     img1_colbg = 1; % start position of image 1
% %     img1_colend = img1_colbg + img1_cols - ct; % end position of image 1
% % else
% %     img1_colbg = img2_cols+1;
% %     img1_colend = nc;
% % end
% img1_colbg = 2 - min_ci;
% img1_colend = img1_colbg + img1_cols + 1;
% img1_rowbg = 2 -min_ci;
% img1_rowend = img1_rowbg + img1_rows + 1;
% img(img1_rowbg:img1_rowend,img1_colbg+img1_colend) = img1;
img = uint8(img);
end

