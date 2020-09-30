function vol = Swi();

%% Importing and preparing the data
%Importing the data
if nargin == 0
    [fileMag, pathMag] = uigetfile('*.nii', 'Choose magnitude images');
    [filePhase, pathPhase] = uigetfile('*.nii', 'Choose phase images');   
end

%Reading the phase and magnitude, then determining dimensions
mag = niftiread(strcat(pathMag, '/', fileMag)); [magSizeX, magSizeY, magSizeZ] = size(mag);
phase = niftiread(strcat(pathPhase, '/', filePhase)); [phaseSizeX, phaseSizeY, phaseSizeZ] = size(phase);

%Rotating the magnitude and phase images
mag = rot90_3D(mag, 1, 3); phase = rot90_3D(phase, 1, 3);

%Calculating the comp according to the euler equation m*e^(i*phase)
comp = mag.*exp(i*(phase + pi));

%% Creating a hanning filter, according to Hecke et al.
%Choosing size 70, however this can be changed.
filterSize = 70;
filter = hanning(filterSize)*hanning(filterSize)';

% Setting the filter size to equal the array size
pad = (magSizeX-filterSize)/2; filter = padarray(filter, [pad pad]);

%Shifting the filter
filter = fftshift(filter);

%% Applying low and high pass filters

%For each slice, calculating the frequency comp then applying the filter to
%that and inverse forierransfroming which creates a lowpass filter stored
%in lpslice. To create a high pass filter, every comp slice is divided by the
%corrosponding lpslice and the value is assigned to hpcomp.
for o = 1:magSizeZ
    lpslice = ifft2(fft2(comp(:,:,o)).*filter);
    hpcomp(:,:,o) = comp(:,:,o)./lpslice;
end

% Applying the inverse of the euler equation we get phase again. 
hpphase = angle(hpcomp);

%% Calculating the phaseMask
% Preallocation

phaseMask = zeros(magSizeX, magSizeY, magSizeZ);

% Rescaling all values between -pi and 0 to 0 to 1. Everything above 0 is set to 1.
phaseMask = hpphase/pi + 1; phaseMask(phaseMask > 1) = 1;

%% Creating the SWI

%Preallocations
volSwi = zeros(magSizeX, magSizeY, magSizeZ); volMin = zeros(magSizeX, magSizeY, magSizeZ/4); volMean = zeros(magSizeX, magSizeY, magSizeZ/4); volMax = zeros(magSizeX, magSizeY, magSizeZ/4);

%phaseMask ^4 then multiplying it by the magnitude image. 4 comes from
%Hacke et al's original paper.
volSwi = phaseMask.^4.*mag;


for slice = 1:magSizeZ/4
    if (slice-1)*4+8 < 512
    volMin(:,:, slice) = min(volSwi(:,:, (slice-1)*4+1:(slice-1)*4+8), [], 3);
    volMean(:,:, slice) = min(volSwi(:,:, (slice-1)*4+1:(slice-1)*4+8), [], 3);
    volMax(:,:, slice) = min(volSwi(:,:, (slice-1)*4+1:(slice-1)*4+8), [], 3);
    else
    volMin(:,:, slice) = min(volSwi(:,:, (slice-1)*4+1:(slice-1)*4+4), [], 3);
    volMean(:,:, slice) = min(volSwi(:,:, (slice-1)*4+1:(slice-1)*4+4), [], 3);
    volMax(:,:, slice) = min(volSwi(:,:, (slice-1)*4+1:(slice-1)*4+4), [], 3);
    end
end

vol.swi = volSwi;
vol.min = volMin;
vol.max = volMax;
vol.mean = volMean;
vol.mag = mag;

