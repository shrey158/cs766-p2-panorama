% [T, matches] = align(des1, locs1, des2, locs2, dR, p, tol)
% input:
%   des1 - the feature descriptors of the first image
%   locs1 - the feature locations of the first image
%   des2 - the feature descriptors of the second image
%   locs2 - the feature locations of the second image
%   dR - distance ratio used in the Lowe's method for matching
%   p - the probability of real inliers assumed for the RANSAC algorithm
%   tol - the tolerance for inlier
%
% output:
%   T - the translation matrix from the second image to the first image
%   matches - the list of matching pairs used to compute the translation
%
% function description:
% This function takes two image as input. First, the function
% calculates the SIFT feature sets of the two input images. Then, the
% function uses the Lowe's method to find the initial matching features in
% the two images. For the initial matching features, the RANSAC algorithm
% is used to further eliminate outliers. Translation is finally calculated
% as the average translation of the largest set of inlier matching features.

function [T, matches] = align(des1, locs1, des2, locs2, dR, p, tol)

% find the initial matches using the Lowe's method
intiMatchIndices = loweMatch(des1, des2, dR);

% use RANSAC algorithm to search for the matches
P = 0.99; % the probability of success
k = ceil(log(1-P)/log(1-p)); % the number of iteration needed
matchIndices = zeros(1,2);
% run k iterations
for itri = 1:k
    
    % calculate the estimated translation
    coord1 = locs1(intiMatchIndices(itri,1),:);
    coord2 = locs2(intiMatchIndices(itri,2),:);
    rowt = coord1(1) - coord2(1);
    colt = coord1(2) - coord2(2);
    
    % go through the rest of the matching pairs and find inliers
    tmpMatchIndices = intiMatchIndices(itri,:);
    for testi = 1:k
        if testi ~= itri
            coord1_t = locs1(intiMatchIndices(testi,1),:);
            coord2_t = locs2(intiMatchIndices(testi,2),:);
            ssd = sqrt(((coord2_t(1)+rowt-coord1_t(1))^2 ...
                    + (coord2_t(2)+colt-coord1_t(2))^2)/2);
            incount = 1;
            % if the test pair is an inlier
            if ssd < tol
                incount = incount+1;
                tmpMatchIndices(incount,1) = intiMatchIndices(testi,1);
                tmpMatchIndices(incount,2) = intiMatchIndices(testi,2);
            end
        end
    end
    
    % update to the largest match set
    if size(matchIndices,1) < size(tmpMatchIndices,1)
        matchIndices = tmpMatchIndices;
    end
end

% calculate the final translation from the second image to the first image
T = zeros(1,2);
matches = zeros(size(matchIndices,1),size(locs1,2),2);
for m = 1:size(matchIndices,1)
    coord1 = locs1(matchIndices(1,1),:);
    coord2 = locs2(matchIndices(1,2),:);
    rowt = coord1(1) - coord2(1);
    colt = coord1(2) - coord2(2);
    T(1,1) = T(1,1)+rowt;
    T(1,2) = T(1,2)+colt;
    matches(m,:,1) = coord1;
    matches(m,:,2) = coord2;
end
T = T/size(matchIndices,1);

end



% Quoted from the match.m file from 
% http://www.cs.ubc.ca/~lowe/keypoints/siftDemoV4.zip with modification
% This function takes two images' feature descriptor sets and find the 
% match. In the return, each row contains two indices, i and j, meaning the
% ith feature in the first image is matched to the jth feature of the
% second image. The total number of rows in the return is the total number
% of matches found.
function matchIndices = loweMatch(des1, des2, distRatio)

% For each descriptor in the first image, select its match to second image.
des2t = des2';                          % Precompute matrix transpose
count = 0;
matchIndices = zeros(1,2);
for i = 1 : size(des1,1)
   dotprods = des1(i,:) * des2t;        % Computes vector of dot products
   [vals,indx] = sort(acos(dotprods));  % Take inverse cosine and sort results

   % Check if nearest neighbor has angle less than distRatio times 2nd.
   if (vals(1) < distRatio * vals(2))
      count = count + 1;
      matchIndices(count,1) = i;
      matchIndices(count,2) = indx(1);
   end
end
end