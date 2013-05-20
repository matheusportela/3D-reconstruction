function image = read_image(imagenumber)

imageFileNumber = sprintf('%.2d', imagenumber);
imageFile = strcat('/data/images/', imageFileNumber, '.jpg');
image = imread(imageFile);

return