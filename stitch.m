% [imgBuff, delT] = stitch(imgBuff1, imgBuff2, T)
% input
%   imgBuff1 - the first image buffer
%   imgBuff2 - the second image buffer
%   T - the translation from image2 to image1, i.e., (x2,y2)+T = (x1,y1).
% output
%   imgBuff - the output stitched/blended image buffer
%   delT - the translation from image1 to the stitched image, i.e.,
%   (x1,y1)+delT = (x,y).
% function description:
% This function takes two images and stitches them together by applying
% some blending effect.

function [imgBuff, delT] = stitch(imgBuff1, imgBuff2, T)
%% Set up the resulting painting plane
[nRows1, nCols1, nChnls] = size(imgBuff1);
[nRows2, nCols2, ~] = size(imgBuff2);
rT = T(1);
cT = T(2);
delT = [1-min(1,1+rT),1-min(1,1+cT)];
nRows = max(nRows1, nRows2+rT) + delT(1);
nCols = max(nCols1, nCols2+cT) + delT(2);
imgBuff = double(zeros(nRows, nCols, nChnls));

%% Getting some coordinate ranges
toGlbT1 = delT; % the translation from image 1 to glable image
toGlbT2 = T + delT; % the translation from image 2 to globle image
glbCRange1 = (1:nCols1)+toGlbT1(2);
glbCRange2 = (1:nCols2)+toGlbT2(2);
glbRRange1 = (1:nRows1)+toGlbT1(1);
glbRRange2 = (1:nRows2)+toGlbT2(1);

%% Create the blending masks
[~,cIntersect1, cIntersect2] = intersect(glbCRange1, glbCRange2);
[~,rIntersect1, rIntersect2] = intersect(glbRRange1, glbRRange2);
alpha = 100;
mask1 = getMask(cIntersect1, imgBuff1,alpha);
mask2 = getMask(cIntersect2, imgBuff2,alpha);
flag1 = imgBuff1(rIntersect1,cIntersect1,end);
flag2 = imgBuff2(rIntersect2,cIntersect2,end);
flag1 = 1-flag1;
flag2 = 1-flag2;
mask1(rIntersect1,cIntersect1) = ...
    max(mask1(rIntersect1,cIntersect1),double(flag2));
mask2(rIntersect2,cIntersect2) = ...
    max(mask2(rIntersect2,cIntersect2),double(flag1));

%% Stitching the images
for i = 1:nChnls-1
    imgBuff(glbRRange1,glbCRange1,i) = ...
        imgBuff(glbRRange1,glbCRange1,i) + double(imgBuff1(:,:,i)).*mask1;
end
for i = 1:nChnls-1
    imgBuff(glbRRange2,glbCRange2,i) = ...
        imgBuff(glbRRange2,glbCRange2,i) + double(imgBuff2(:,:,i)).*mask2;
end
imgBuff(glbRRange1,glbCRange1,end) = ...
       max(imgBuff(glbRRange1,glbCRange1,end),double(imgBuff1(:,:,end)));
imgBuff(glbRRange2,glbCRange2,end) = ...
       max(imgBuff(glbRRange2,glbCRange2,end),double(imgBuff2(:,:,end)));
imgBuff = uint8(imgBuff);
end

% create a blending mask
function mask = getMask(lclCRange, imgBuff, alpha)
    [nRows, nCols, ~] = size(imgBuff);
    mask = ones(nRows, nCols);
    ratios = (lclCRange - lclCRange(1))/(lclCRange(end)-lclCRange(1));
    
    if lclCRange(1) ~= 1
        ratios = fliplr(ratios);
    end
%     ratios = atan(alpha*(ratios-0.5))/pi+0.5;
%     ratios = ratios*alpha;
%     ratios = ratios+(1-alpha)/2;
%     ratios = tan((ratios-0.5)/2*pi)/2+0.5;
%     ratios = sign(ratios-0.5).*(0.5-sqrt(0.25-(ratios-0.5).^2))+0.5;
    for i = 1:nRows
        mask(i,lclCRange) = ratios;
    end
end
