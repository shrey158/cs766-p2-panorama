%% INITIALIZING WORKING SPACE 
% clear the existing variables
clc, clear all;

%% INPUT CONFIGURATION
% ask the user for input path
filepath = input('Please type in the input directory ending with /:', 's');

% setup input/output
fid = fopen([filepath,'runconfig.txt']);
if fid < 0
    error('No input configuration in the directory');
end
f = str2double(fgets(fid));   % get the focal length
k1 = str2double(fgets(fid));   % get k1
k2 = str2double(fgets(fid));   % get k2

filelist = cell(0,0);
filename = fgetl(fid);
while ischar(filename)
    filelist = [filelist; filename];    % get the image list
    filename = fgetl(fid);
end
fclose(fid);
outputfile = 'pano.JPG';
format = 'jpg';

% setup parameters for RANSAC
dr = 0.6;
p = 0.5;
err = 5;
%% IMAGE UNDISTORTION AND CYLINDRICALIZATION
wkset = struct('imgBuff',zeros(1,1),'des',zeros(1,1), 'locs', zeros(1,1), ...
               't2prev',zeros(1,1),'matches',zeros(1,1));

for i = 1:size(filelist,1)
    img = imread([filepath,filelist{i,1}], format);
    [nRows, nCols, nClrs] = size(img);
    imgBuff = zeros(nRows, nCols, nClrs+1);
    imgBuff(:,:,end) = 1;
    imgBuff(:,:,1:nClrs) = img;
    imgBuff = undistort(imgBuff,f,k1,k2,1);
    imgBuff = cylindrical(imgBuff,f);
    wkset(i,1) = struct('imgBuff',imgBuff, ...
                        'des', zeros(1,1), ...
                        'locs', zeros(1,1), ...
                        't2prev',zeros(1,1), ...
                        'matches',zeros(1,1));
end

%% EXTRACT THE SIFT FEATURES
for i = 1:size(filelist,1)
    imgBuff = wkset(i).imgBuff;
    [des, locs] = sift(imgBuff(:,:,1:end-1));
    wkset(i).des = des;
    wkset(i).locs = locs;
end


%% PAIRWISE TRANSLATION ESTIMATION
for i = 2:size(wkset,1)
    des1 = wkset(i-1).des;
    locs1 = wkset(i-1).locs;
    des2 = wkset(i).des;
    locs2 = wkset(i).locs;
    [wkset(i).t2prev, wkset(i).matches] = ...
            align(des1, locs1, des2, locs2,dr,p,err);    
end

%% STITCH/BLEND IMAGES
T = zeros(1,2);
imgBuff = wkset(1).imgBuff;
for i = 2:size(wkset,1)
    T = T+wkset(i).t2prev;
    [imgBuff,delT] = stitch(imgBuff, wkset(i).imgBuff, T);
    T = T+delT;
end

%% REMOVE THE DRIFT OF THE PANORAMA
drift = 0;
for i = 2:size(wkset,1)
    drift = drift + wkset(i).t2prev(1);
end
imgBuff = affine(imgBuff, drift);

%% CROPPING THE IMAGE
% crop out black boundaries
[nRows, nCols, ~] = size(imgBuff);
r1 = 1;
while max(imgBuff(r1,:,end)) == 0
    r1 = r1+1;
end
r2 = nRows;
while max(imgBuff(r2,:,end)) == 0
    r2 = r2-1;
end
c1 = 1;
while max(imgBuff(:,c1,end)) == 0
    c1 = c1+1;
end
c2 = nCols;
while max(imgBuff(:,c2,end)) == 0
    c2 = c2-1;
end
wkset(i).imgBuff = crop(imgBuff,r1,c1,r2,c2);
% crop out all rest no-scene area and cut the end images in half
[~,nCols0,~] = size(wkset(1).imgBuff);
c1 = floor(nCols0/2);
c2 = nCols - c1;
r1 = 1;
while min(imgBuff(r1,c1:c2,end)) == 0
    r1 = r1+1;
end
r2 = nRows;
while min(imgBuff(r2,c1:c2,end)) == 0
    r2 = r2-1;
end
imgBuff = crop(imgBuff,r1,c1,r2,c2);

%% SHOW IMAGE
imshow(imgBuff(:,:,1:end-1));

%% OUTPUT
imwrite(imgBuff(:,:,1:end-1), [filepath,outputfile], format);
