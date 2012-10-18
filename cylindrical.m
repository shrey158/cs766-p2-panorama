function outputImg = cylindrical(inputImg, f)

R = f;
Z = f;

% read the image in
imgSize = size(inputImg);
numRows = imgSize(1);
numCols = imgSize(2);
numClrs = imgSize(3);
outputImg = zeros(numRows,numCols,numClrs);


% inverse warping
% for each pixel in the resulting warped image
for row = 1:numRows
    for col = 1:numCols
        % the cylinder coordinates
        x_cyl = col - floor(numCols/2);
        y_cyl = -(row - floor(numRows/2));

        % the cylinder coordinates in theta and h
        theta = x_cyl/R;
        h = y_cyl;

        % the unwarped imgage plane coordinates
        x = tan(theta)*Z;
        y = h/R*sqrt(x^2+Z^2);

        % the positions of the unwarped coordinates
        % note: these two position indices are doubles
        col_index = x + floor(numCols/2);
        row_index = floor(numRows/2) - y;
        
        % inverse warping using biliniar interperation
        if ((row_index > 1 && row_index < numRows)&& ...
              (col_index > 1) && (col_index < numCols))
            outputImg(row,col,:) = findIntensity(inputImg,[col_index row_index]);
        end
    end
end
outputImg = uint8(outputImg);
end

