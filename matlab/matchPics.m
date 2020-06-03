function [ locs1, locs2] = matchPics( I1, I2 )
%MATCHPICS Extract features, obtain their descriptors, and match them!

    use_SURF = false;


%% Convert images to grayscale, if necessary

    if (ndims(I1) == 3)
        I1 = rgb2gray(I1);
    end
    if (ndims(I2) == 3)
        I2 = rgb2gray(I2);
    end

%% Detect features in both images
    if(use_SURF)
        points1 = detectSURFFeatures(I1);
        points2 = detectSURFFeatures(I2);
    else
        points1 = detectFASTFeatures(I1);
        points2 = detectFASTFeatures(I2);
    end

%% Obtain descriptors for the computed feature locations
    
    if(use_SURF)
        [desc1, plocs1] = extractFeatures(I1, points1.Location, 'Method', 'SURF');
        [desc2, plocs2] = extractFeatures(I2, points2.Location, 'Method', 'SURF');
    else
        [desc1, plocs1] = computeBrief(I1, points1.Location);
        [desc2, plocs2] = computeBrief(I2, points2.Location);
    end

%% Match features using the descriptors
    
    [indexPairs, ~] = matchFeatures(desc1, desc2, 'MatchThreshold', 100.0, 'MaxRatio', 0.7);

    
    temp_n = size(indexPairs,1);
    locs1 = zeros(temp_n,2);
    locs2 = zeros(temp_n,2);
%%

    if(use_SURF)
        for i = 1:temp_n
            locs1(i,:) = plocs1.Location(indexPairs(i,1),:);
            locs2(i,:) = plocs2.Location(indexPairs(i,2),:);
        end
    else
        for i = 1:temp_n
            locs1(i,:) = plocs1(indexPairs(i,1),:);
            locs2(i,:) = plocs2(indexPairs(i,2),:);
        end
    end
    
    %figure;
    %showMatchedFeatures(I1, I2, locs1, locs2, 'montage');
end

