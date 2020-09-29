function mapped_image = mapImage(filename, format)
% Magexport takes a file and then exports it as a series of images in a
% directory to be used in imageJ. The directory name is then encrypted to
% blind the user.
%
% FILENAME should be a .nii file. SAMPLENUMBER should be a character
% vector.

% Importing and rotating the image (I have no idea what I am doing, but
% this seems to work).
mag = niftiread(filename); mag = rot90_3D(mag, 1, 3); mag = imrotate(mag, 90); mag = imrotate3(mag, 90, [0 1 0]); mag = imrotate(mag, -90);

%Rescaling the color map if it is an image.
if(strcmp(format, '.img')) %|| strcmp(format, '.dcm'))
    minD = min(0);
    maxD = max(300000);
    mapped_image = (double(mag) - minD) ./ (maxD - minD);
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
    mapped_image = mag;
end