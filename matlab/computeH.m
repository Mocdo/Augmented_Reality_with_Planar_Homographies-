function [ H2to1 ] = computeH( x1, x2 )
%COMPUTEH Computes the homography between two sets of points
%%
    size_x = size(x1,1);
    A = zeros(size_x*2,9);
    for i = 1:size_x
        A(i*2-1,:) = [-x2(i,1), -x2(i,2), -1, 0,0,0, x2(i,1)*x1(i,1), x2(i,2)*x1(i,1), x1(i,1)];
        A(i*2,:)  =  [0,0,0, -x2(i,1), -x2(i,2), -1, x2(i,1)*x1(i,2), x2(i,2)*x1(i,2), x1(i,2)];
    end

    [u, s, v] = svd(A);
    
    solu = v(:,end);
    
    H2to1 = [solu(1),solu(2),solu(3);
             solu(4),solu(5),solu(6);
             solu(7),solu(8),solu(9)];

end
