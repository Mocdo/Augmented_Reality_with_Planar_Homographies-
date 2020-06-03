function [ bestH2to1, inliers] = computeH_ransac( locs1, locs2)
%COMPUTEH_RANSAC A method to compute the best fitting homography given a
%list of matching points.

    distance_the = 20;
    num_of_iter = 100;
%Q2.2.3

    size_n = size(locs1,1);
    if(size_n<4)
       error(message('Too few features.')); 
    end
    
    temp_inliers = zeros(num_of_iter,size_n);
    
    for i=1:num_of_iter
        tmp = randperm(size_n,4);
        tmp_locs1 = [locs1(tmp(1),:);locs1(tmp(2),:);locs1(tmp(3),:);locs1(tmp(4),:)];
        tmp_locs2 = [locs2(tmp(1),:);locs2(tmp(2),:);locs2(tmp(3),:);locs2(tmp(4),:)];
        tmp_H = computeH_norm(tmp_locs1, tmp_locs2);
        
       for j = 1:size_n
           
           point1 = [locs1(j,1);locs1(j,2)]; 
           point2 = tmp_H*[locs2(j,1);locs2(j,2);1];
           point2 = point2./point2(3);
           point2 = point2(1:2);
           diff = norm(point1-point2);
           if(diff <= distance_the)
               temp_inliers(i,j)=1;
           end
       end
    end


    
    
    count_inliers = sum(temp_inliers,2);
    [~, index] = max(count_inliers);
    
    %%
    inliers = temp_inliers(index,:);
    %%
    num = size(inliers,1);
    new_locs1 = zeros(num,2);
    new_locs2 = zeros(num,2);
    
    c=0;
    for i=1:size_n
       if(inliers(i)==1)
          c=c+1;
          new_locs1(c,:)= locs1(i,:);
          new_locs2(c,:)= locs2(i,:);
       end
    end
    
%     figure(1);
%     showMatchedFeatures(cv_img, I2, new_locs1, new_locs2, 'montage');
    %%
    bestH2to1 = computeH_norm(new_locs1, new_locs2);

end



