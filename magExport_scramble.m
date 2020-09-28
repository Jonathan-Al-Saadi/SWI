function magExport_scramble(filename, samplenumber)

%Mapping the image from 0 - 256
mapped_image = mapImage(filename);

%Creating a folder with encrypted name, leaving a key in the folder.
dirPath = scrambler(samplenumber);

% Adding the images to that folder
cd(dirPath);

for slice = 1:size(mapped_image, 3)
imwrite(mapped_image(:,:,slice), strcat(sprintf('image%.3d', slice), '.tif'));
end

cd('..');