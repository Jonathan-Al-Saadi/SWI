function magExport_scramble(filename, samplenumber, format)

%Mapping the image from 0 - 256
mapped_image = mapImage(filename, format);

%Creating a folder with encrypted name, leaving a key in the folder.
dirPath = scrambler(samplenumber);

% Adding the images to that folder
cd(dirPath);


switch format
    case '.tif'
        imwrite(mapped_image(:,:,slice), strcat(sprintf('image%.3d', slice), '.tif'));
    case '.nii'
        niftiwrite(mapped_image, dirPath);
    case '.dcm'
        [x, y, slice] = size(mapped_image);
        mapped_image = uint16(mapped_image);
        dicomwrite(reshape(mapped_image, [x,y,1,slice]), strcat(dirPath, '.dcm'));
    otherwise
        warning('Unexpected format. No export created. Use ''.tif'', ''.dicom'' or ''.nii''')
end

cd('..');