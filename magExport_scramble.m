function magExport_scramble(samplenumber, format)
% Magexport takes a file and then exports it as a series of images in a
% directory to be used in imageJ. The directory name is then encrypted to
% blind the user.
%If user inputs filename as Swi, we calculate the SWI. Otherwise the
%function just reads the img.


vol = Swi();

%Mapping the image from 0 - 256 if .img or dicom otherwise just rotating it.
mapped_mag = mapImage(vol.mag, format);
mapped_swi = mapImage(vol.swi, format);
mapped_hpphase = mapImage(vol.hpphase, format);

%Creating a folder with encrypted name, leaving a key in the folder.
dirPath = scrambler(samplenumber);

% Adding the images to that folder
cd(dirPath);


switch format
    case '.tif'
        for slice = 1:size(mapped_mag, 3)
            imwrite(mapped_mag(:,:,slice), strcat(sprintf('Mag%.3d', slice), '.tif'));
            imwrite(mapped_swi(:,:,slice), strcat(sprintf('Swi%.3d', slice), '.tif'));
            imwrite(mapped_hpphase(:,:,slice), strcat(sprintf('HPHASE%.3d', slice), '.tif'))
        end
    case '.nii'
        niftiwrite(mapped_mag, 'MAG.nii');
        niftiwrite(mapped_swi, 'SWI.nii');
        niftiwrite(mapped_hpphase, 'HPHASE.nii');
    case '.dcm'
        [x, y, slice] = size(mapped_mag);
        mapped_mag = uint16(mapped_mag); mapped_swi = uint16(mapped_swi); mapped_hpphase = uint16(mapped_hpphase); %Converting to uint16, which is obligatory for dicom.
        dicomwrite(reshape(mapped_mag, [x,y,1,slice]), 'MAG.dcm');
        dicomwrite(reshape(mapped_swi, [x,y,1,slice]), 'SWI.dcm');
        dicomwrite(reshape(mapped_hpphase, [x,y,1,slice]), 'HPHASE.dcm');
    otherwise
        warning('Unexpected format. No export created. Use ''.tif'', ''.dicom'' or ''.nii''')
end

cd('..');