function [intensityP] = findIntensity(oldIm,oldPoint)
%FINDINTENSITY uses bilinear interpolation to find out the intensity of the
% points
% oldIm is M by N by 3 matrix and oldPoint is a 1 by 2 matrix [x0, y0]
x0 = floor(oldPoint(1));
x1 = x0 + 1;
y0 = floor(oldPoint(2));
y1 = y0 + 1;
dx = oldPoint(1) - x0;
dy = oldPoint(2) - y0;
intensityP =(1-dx)*(1-dy)*oldIm(y0,x0,:)+dy*(1-dx)*oldIm(y1,x0,:)+dx*(1-dy)*oldIm(y0,x1,:)+dx*dy*oldIm(y1,x1,:);
intensityP=uint8(round(intensityP));
