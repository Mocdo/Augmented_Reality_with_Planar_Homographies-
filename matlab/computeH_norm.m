function [H2to1] = computeH_norm(x1, x2)


%% Compute centroids of the points

centroid1 = mean(x1);
centroid2 = mean(x2);

%% Shift the origin of the points to the centroid
for i = 1:size(x1,1)
    x1(i,:) = x1(i,:) - centroid1;
end
for i = 1:size(x2,1)
    x2(i,:) = x2(i,:) - centroid2;
end
%% Normalize the points so that the average distance from the origin is equal to sqrt(2).

norm_max1 = zeros(size(x1,1),1);
for i = 1:size(x1,1)
    temp_norm = norm(x1(i,:));
    
    norm_max1(i) = temp_norm;
    
end
scale1 = sqrt(2)/max(norm_max1);

norm_max2 = zeros(size(x2,1),1);
for i = 1:size(x2,1)
    temp_norm = norm(x2(i,:));
   
    norm_max2(i) = temp_norm;
   
end
scale2 = sqrt(2)/max(norm_max2);

for i = 1:size(x1,1)
    x1(i,:) = x1(i,:).*scale1;
end
for i = 1:size(x2,1)
    x2(i,:) = x2(i,:).*scale2;
end

%% similarity transform 1
T1 = [scale1,0,0;
      0,scale1,0;
      0,0,1];
T1 = T1* [1,0,-centroid1(1);
          0,1,-centroid1(2);
          0,0,1];

%% similarity transform 2
T2 = [scale2,0,0;
      0,scale2,0;
      0,0,1];
T2 = T2* [1,0,-centroid2(1);
          0,1,-centroid2(2);
          0,0,1]; 
%% Compute Homography
%for i = 1:size(x1,1)
%    x1(i,3)=1;
%end
%for i = 1:size(x2,1)
%    x2(i,3)=1;
%end

H = computeH( x1, x2 );


%% Denormalization
H2to1 = T1\H*T2;
