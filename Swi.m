function vol = Swi();

%% Reading the phase and magnitude, then determining dimensions
mag = niftiread('/Users/jonathan/Desktop/s_20200609_Gris7hjarna/Pig7mge3d.nii/MG/image004.nii'); [magSizeX, magSizeY, magSizeZ] = size(mag);
phase = niftiread('/Users/jonathan/Desktop/s_20200609_Gris7hjarna/Pig7mge3d.nii/PH/image004.nii'); [phaseSizeX, phaseSizeY, phaseSizeZ] = size(phase);

%% Rotating the magnitude and phase images
mag = rot90_3D(mag, 1, 1); phase = rot90_3D(phase, 1, 1);

%%Calculating the comp according to the euler equation m*e^(i*phase)
comp = mag.*exp(i*(phase + pi));

%%Creating a hanning filter, according to Hecke et al.
filterSize = 70;
filter = hanning(filterSize)*hanning(filterSize)';

%Setting the filter size to equal the array size
pad = (magSizeX-filterSize)/2; filter = padarray(filter, [pad pad]);

%Shifting the filter
filter = fftshift(filter);

%For each slice, calculating the frequency comp then applying the filter to
%that and inverse forierransfroming which creates a lowpass filter stored
%in lpslice. To create a high pass filter, every comp slice is divided by the
%corrosponding lpslice and the value is assigned to hpcomp.
for o = 1:magSizeZ
    lpslice = ifft2(fft2(comp(:,:,o)).*filter);
    hpcomp(:,:,o) = comp(:,:,o)./lpslice;
end

%% Applying the inverse of the euler equation we get phase. 
hpphase = angle(hpcomp);

phaseMask = zeros(magSizeX, magSizeY, magSizeZ);

%% Rescaling all values between -pi and 0 to 0 to 1. Everything above 0 is set to 1.
for slice = 1:magSizeZ
    for yDim = 1:magSizeY
        for xDim = 1:magSizeX
            if hpphase(xDim, yDim, slice) >= 0
                phaseMask(xDim, yDim, slice) = 1;
            else
                phaseMask(xDim, yDim, slice) = hpphase(xDim, yDim, slice)/pi +1;
            end
        end
    end
end

%% Creating the SWI
%phaseMask ^4 then multiplying it by the magnitude image. 4 comes from
%Hacke et al's original paper.
vol = phaseMask.^4.*mag;


    
    