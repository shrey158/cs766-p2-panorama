% clear the existing variables
clc, clear;

% ask the user for input path
filepath = input('Please type in the input directory ending with /:', 's');

% setup input/output
fid = fopen([filepath,'runconfig.txt'],'r');
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

% setup parameters
dr = 0.6;
p = 0.5;
err = 5;

% warp the images into cylindrical coordinate and store their SIFT
% features with them
wkset = struct('img',zeros(1,1),'des',zeros(1,1), 'locs', zeros(1,1), ...
               't2prev',zeros(1,1),'matches',zeros(1,1));
for i = 1:size(filelist,1)
    img = imread([filepath,filelist{i,1}], format);
    [des, locs] = sift(img);
    wkset(i,1) = struct('img',cylindrical(img,f), ...
                        'des', des, ...
                        'locs', locs, ...
                        't2prev',zeros(1,1), ...
                        'matches',zeros(1,1));
end

% calculate pairwise translation
for i = 2:size(wkset,1)
    des1 = wkset(i-1).des;
    locs1 = wkset(i-1).locs;
    des2 = wkset(i).des;
    locs2 = wkset(i).locs;
    [wkset(i).t2prev, wkset(i).matches] = ...
            align(des1, locs1, des2, locs2,dr,p,err);    
end

% stitch/blend the imgages
T = zeros(1,2);
img = wkset(1).img;
for i = 2:size(wkset,1)
    T = T+wkset(i).t2prev;
    [img,delT] = stitch(img, wkset(i).img, T);
    T = T-delT;
end

% output the panorama
imwrite(img, [filepath,outputfile], format);