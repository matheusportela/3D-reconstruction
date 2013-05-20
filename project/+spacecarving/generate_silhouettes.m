function generate_silhouettes()
%% generate silhouettes
    import spacecarving.*;

    for j=0:23
        image = read_image(j);
        contour = read_contour(j);
    %     mask = poly2mask(contour(:,1),contour(:,2),size(image,1),size(image,2));
    %     figure;
    %     test = [rgb2gray(image) 255*mask];
    %     imshow(test);



    % [X Y] = points2contour(contour(:,1), contour(:,2), 1, 'cw', 40);
    % 
    % plot(X,Y, 'xr');
    % hold on;
    % plot(contour(:,1), contour(:,2), '.b');

        A = zeros(size(image,1),size(image,2));
        for i = 1: size(contour, 1)
            A(uint32(contour(i,2)), uint32(contour(i,1))) = 1;
        end

        se= [0 1 0; 1 1 1; 0 1 0];    

        A = imdilate(A, se1);
        A = imdilate(A, se1);
        A = imerode(A, se1);
        A = imdilate(A, se1);
        A = imerode(A, se1);
        A = imdilate(A, se1);
        A = imerode(A, se1);
        A = imdilate(A, se1);
        A = imerode(A, se1);

        B = imfill(A);

        SI(j+1).si = B;

    end

%     %% TEST - vizualize silhouettes
%     for i = 1:24
%         image = read_image(i-1);
%         aux = [rgb2gray(image) SI(i).si*255];
%     %     aux = SI(i).si*255;
% 
%         imshow(aux);
%         pause(0.05);
%         figure
%         imshow(aux)
%     end
end
    
    
    