% Your solution to Q2.1.5 goes here!

%% Read the image and convert to grayscale, if necessary
clear all;
close all;

cv_img = imread('../data/cv_cover.jpg');
if(ndims(cv_img)==3)
   cv_img = rgb2gray(cv_img); 
end

%% Compute the features and descriptors
%points1 = detectFASTFeatures(cv_img);
%[desc1, plocs1] = computeBrief(cv_img, points1.Location);

points1 = detectSURFFeatures(cv_img);
[desc1, plocs1] = extractFeatures(cv_img, points1.Location, 'Method', 'SURF');

%%
count_numof_matches = zeros(1,36);
for i = 0:35
    %% Rotate image
    
    I2 = imrotate(cv_img, 10*i);
    
    %% Compute features and descriptors
    
    %points2 = detectFASTFeatures(I2);
    %[desc2, plocs2] = computeBrief(I2, points2.Location);

    points2 = detectSURFFeatures(I2);
    [desc2, plocs2] = extractFeatures(I2, points2.Location, 'Method', 'SURF');


    %% Match features
    
    [indexPairs, ~] = matchFeatures(desc1, desc2, 'MatchThreshold', 10.0, 'MaxRatio', 0.1);

    %% Update histogram
    
    count_numof_matches(i+1) = size(indexPairs,1);
%     if(i==10 || i==19 ||i==25)
%         temp_n = size(indexPairs,1);
%     locs1 = zeros(temp_n,2);
%     locs2 = zeros(temp_n,2);
%     for j = 1:temp_n
%         locs1(j,:) = plocs1.Location(indexPairs(j,1),:);
%         locs2(j,:) = plocs2.Location(indexPairs(j,2),:);
%     end
% 
%     figure;
%     showMatchedFeatures(cv_img, I2, locs1, locs2, 'montage');    
%     end
end

%% Display histogram

figure;
plot((0:10:350),count_numof_matches);
xlabel('Angle in degree')
ylabel('Num of Matches')