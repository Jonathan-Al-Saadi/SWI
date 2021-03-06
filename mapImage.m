function img = mapImage(img, format)
% Magexport takes a file and then exports it as a series of images in a
% directory to be used in imageJ. The directory name is then encrypted to
% blind the user.
%
% FILENAME should be a .nii file. SAMPLENUMBER should be a character
% vector.

% Importing and rotating the image (I have no idea what I am doing, but
% this seems to work).
img = rot90_3D(img, 1, 3); img = imrotate(img, 90); img = imrotate3(img, 90, [0 1 0]); img = imrotate(img, -90);

%Rescaling the color map if it is an image.
if(strcmp(format, '.img'))
    minD = min(0);
    maxD = max(300000);
    mapped_image = (double(img) - minD) ./ (maxD - minD);
    ncmap = size(colormap, 1);
    mapped_image = mapped_image .* ncmap;
    if ncmap == 2
        mapped_image = mapped_image >= 0.5;  %logical
    elseif ncmap <= 256
        mapped_image = uint8(mapped_image);
    else
        mapped_image = uint16(mapped_image);
    end
elseif strcmp(format, '.dcm')
    minD = min(0);
    maxD = max(300000);
    mapped_image = (double(img) - minD) ./ (maxD - minD);
    ncmap = size(colormap, 1);
    mapped_image = mapped_image .* ncmap;
    if ncmap == 2
        mapped_image = mapped_image >= 0.5;  %logical
    elseif ncmap <= 256
        mapped_image = uint8(mapped_image);
    else
        mapped_image = uint16(mapped_image);
    end
else
    mapped_image = img;
end