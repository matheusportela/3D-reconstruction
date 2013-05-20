function contour = read_contour(imagenumber)

imageFileNumber = sprintf('%.4d', imagenumber);
imageFile = strcat('data/contour/', imageFileNumber, '.txt');
fp = fileread(imageFile);

%% Parse lines
% match "(float) (float)"
expr = '\d*\.\d* \d*\.\d*';
filetext = regexp(fp, expr, 'match');

%% Convert to numbers
contour = str2num(char(filetext(4:end)));

return