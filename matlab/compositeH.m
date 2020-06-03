function [ composite_img ] = compositeH( H2to1, template, img )
%COMPOSITE Create a composite image after warping the template image on top
%of the image using the homography

% Note that the homography we compute is from the image to the template;
% x_template = H2to1*x_photo
% For warping the template to the image, we need to invert it.
H_template_to_img = (H2to1);


%% Create mask of same size as template
    mask(1:size(template,1),1:size(template,2)) = 255;
%% Warp mask by appropriate homography
    warped_mask = warpH(mask, H_template_to_img, size(img));
    
%% Warp template by appropriate homography
    warped_template = warpH(template, H_template_to_img, size(img));
    
    
%% Use mask to combine the warped template and the image
    composite_img = warped_template;
    for i = 1:size(img,1)
       for j = 1:size(img,2)
          if(warped_mask(i,j)==0) 
              composite_img(i,j,:) = img(i,j,:);
          end
       end
    end
    
    

end