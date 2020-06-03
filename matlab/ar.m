% Q3.3.1
clear;
bookV = loadVid('../data/book.mov');
sourceV = loadVid('../data/ar_source.mov');

cv_img = imread('../data/cv_cover.jpg');
cv_ratio = size(cv_img,2)/size(cv_img,1);

v = VideoWriter('../results/newfile.avi');
open(v);

%%

num_frame_book = size(bookV,2);
num_frame_src  = size(sourceV,2);
%%
for i = 1:num_frame_src
    img_book = bookV(i).cdata;
    img_src = sourceV(i).cdata;
    
    %% deal with src
    img_src_cutsize = uint16(cv_ratio*size(img_src,1));
    img_src_cutleft = uint16((size(img_src,2)-img_src_cutsize)/2);
    %img_src_cutright= img_src_cutleft+img_src_cutsize;
    
    img_src_cutted = imcrop(img_src, [img_src_cutleft, 0, img_src_cutsize, size(img_src,1)]);
    img_src_scaled = imresize(img_src_cutted, [size(cv_img,1) size(cv_img,2)]);
    
    %% deal with book
    [locs1, locs2] = matchPics(cv_img, img_book);
    [bestH2to1, inliers] = computeH_ransac(locs2, locs1);
    img_composited = compositeH(bestH2to1, img_src_scaled, img_book);
    
    %% 
    writeVideo(v,img_composited);
    fprintf('%d/%d\n',i,num_frame_src);

end

if(num_frame_book>num_frame_src)
    
    for i = 1:num_frame_book-num_frame_src
        img_book = bookV(num_frame_src+i).cdata;
        img_src = sourceV(num_frame_src-i).cdata;
    
        %% deal with src
        img_src_cutsize = uint16(cv_ratio*size(img_src,1));
        img_src_cutleft = uint16((size(img_src,2)-img_src_cutsize)/2);
        %img_src_cutright= img_src_cutleft+img_src_cutsize;
    
        img_src_cutted = imcrop(img_src, [img_src_cutleft, 0, img_src_cutsize, size(img_src,1)]);
        img_src_scaled = imresize(img_src_cutted, [size(cv_img,1) size(cv_img,2)]);
    
        %% deal with book
        [locs1, locs2] = matchPics(cv_img, img_book);
        [bestH2to1, inliers] = computeH_ransac(locs2, locs1);
        img_composited = compositeH(bestH2to1, img_src_scaled, img_book);
    
        %% 
        writeVideo(v,img_composited);
        fprintf('%d/%d\n',i+num_frame_src,num_frame_book);

    end
    
end

close(v);