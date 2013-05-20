function SI = generate_silhouettes()
%% generate silhouettes
    import spacecarving.*;

    for j=0:23
        image = read_image(j);
        contour = read_contour(j);

        A = zeros(size(image,1),size(image,2));
        for i = 1: size(contour, 1)
            A(uint32(contour(i,2)), uint32(contour(i,1))) = 1;
        end

        se1= [0 0 0 1 0 0 0; 0 1 1 1 1 1 0; 0 1 1 1 1 1 0; 1 1 1 1 1 1 1; 0 1 1 1 1 1 0; 0 1 1 1 1 1 0;  0 0 0 1 0 0 0];
        se2= [0 1 0; 1 1 1; 0 1 0];    

        A = imdilate(A, se1);
        A = imdilate(A, se1);
        A = imerode(A, se2);
        A = imdilate(A, se1);
        A = imerode(A, se2);
        A = imdilate(A, se1);
        A = imerode(A, se2);
        A = imdilate(A, se1);
        A = imerode(A, se2);

        B = imfill(A);

        SI(j+1).si = B;

    end

%     %% TEST - vizualize silhouettes
%     for i = 1:24
%         image = read_image(i-1);
%         aux = [rgb2gray(image) SI(i).si*255];
%         imshow(aux);
%         pause(0.05);
% %         figure
%         imshow(aux)
%     end
end
    
    
    