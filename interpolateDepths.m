% [depths,flag] = interpolateDepths(imgBuff, r, c)
% input
%   imgBuff - the image buffer from which depth values will be drawn from
%   r - the sub row index of the desired point (can be any real number)
%   c - the sub column index of the desired point (can be any real number)
% output
%   depths - the bilinear interpolated depth values for all color channels
%   flag - the bit to indicate whether the resulting pixel corresponds to
%   any scene point.
%
% function description:
% This function finds the depths of all color channels from a given image
% buffer at [r,c], where r and c may not be integers and require
% interpolation to calculate the depth values from the neighbor pixels.
% Also, the function produces a flag indicating whether the depth values
% are generated based on neighbor pixels among which at least one actual
% scene point exists.


function [depths,flag] = interpolateDepths(imgBuff, r, c)
    % get the number of color channels
    nclrs = size(imgBuff,3) - 1;
    
    % create a 2x2x(nclrs+1) matrix to contain all four neighbor pixels
    neighbors = zeros(2,2,nclrs+1);
    rs = [floor(r), floor(r)+1];
    cs = [floor(c), floor(c)+1];
    [nRows, nCols, ~] = size(imgBuff);
    for i = 1:2
        for j = 1:2
            if inImage(rs(i), cs(j), nRows, nCols) == 1
                neighbors(i,j,:) = imgBuff(rs(i), cs(j), :);
            end
        end
    end
    
    % create the interpolation distributions between rows/columns
    rratios = [rs(2)-r, r-rs(1)];
    cratios = [cs(2)-c, c-cs(1)];
    
    % generate the depth values by bi-linear interpolation
    depths = zeros(1,nclrs);
    for i = 1:nclrs
        depths(1,i) = rratios*neighbors(:,:,i)*cratios';
    end
    flag = max(max(neighbors(:,:,end)));
end

function in = inImage(r, c, nRows, nCols)
    if r >= 1 && r <= nRows && ...
            c >= 1 && c <= nCols
        in = 1;
    else
        in = -1;
    end
end