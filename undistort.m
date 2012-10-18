function desiredImg = undistort(distortedImg,f,k1,k2)
% radial distortion removal. First, image will be resize to size, then
% apply undistortion.
% Input:
% distortedImg: given image should be in landscape to correctly remove the
% distortion. 
% f0 is focal length
% k1 and k2 are two distortion factor, detail in slides
% size is the image resolution you want to change to
% By Qinyuan Sun 10/15/2012

% load camera calibration parameters
% Canon A640, tag 4726208879 for resolution 480x640


[numCols,numRows,numClrs] = size(distortedImg);
% figure(1),imshow(distortedImg);
% title('distorted image')
% xoffset = -floor(numCols/2);
% yoffset = -floor(numRows/2);
% % create the distortion free image
% % initialize the matrix
% outputImg = zeros([numCols,numRows,numClrs]);
% for i = 1:numCols
%     for j = 1:numRows
%         % xn, yn here is coordinates x,y in ideal image, find corresponding points 
%         x = i;
%         y = -j + numRows;
%         xn = (x - xoffset)/f;
%         yn = (y - yoffset)/f;
%         % in distorted image 
%         r = xn*xn + yn*yn;
%         % according to the parameters, get undistorted normalized coordinates
%         xd = xn*(1 +k1*r + k2*r*r);
%         yd = yn*(1 +k1*r + k2*r*r);
%         % translate to the desired cooridinate
%         row_index = numRows - (yoffset + f*yd);
%         col_index = f*xd + xoffset;
%         if ((row_index > 1 && row_index < numRows)&& ...
%               (col_index > 1) && (col_index < numCols))
%             outputImg(j,i,:) = findIntensity(distortedImg,[col_index row_index]);
%         end
%     end
% end
% 
% desiredImg = uint8(outputImg);
% figure(99),imshow(desiredImg);


