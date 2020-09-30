function vol = SwiTester();

%% Importing and preparing the data
%Importing the data
if nargin == 0
    fileMag = uigetdir('Choose magnitude images');
    filePhase = uigetdir('Choose phase images');   
end

%Reading the phase and magnitude, then determining dimensions
for imageN = 1:4
    mag(:,:,:,imageN) = niftiread(strcat(fileMag, sprintf('/image00%.f', imageN))); 
end

[magSizeX, magSizeY, magSizeZ] = size(mag);

for imageN = 1:4
    phase(:,:,:,imageN) = niftiread(strcat(filePhase, sprintf('/image00%.f', imageN))); 
end

[phaseSizeX, phaseSizeY, phaseSizeZ] = size(phase);

%Rotating the magnitude and phase images
mag = rot90_3D(mag, 1, 3); phase = rot90_3D(phase, 1, 3);

%Calculating the comp according to the euler equation m*e^(i*phase)
for imageN = 1:4
    comp = mag(:,:,200,imageN).*exp(i*(phase(:,:,200,imageN) + pi));
end

%% Creating a hanning filter, according to Hecke et al.
%Choosing size 70, however this can be changed.

for filtesize = 1:10
    filter = hanning(filterSize*10)*hanning(filterSize*10)';

    % Setting the filter size to equal the array size
    pad = (magSizeX-filterSize)/2; filter = padarray(filter, [pad pad]);

    %Shifting the filter
    filter = fftshift(filter);

    %% Applying low and high pass filters

    %For each slice, calculating the frequency comp then applying the filter to
    %that and inverse forierransfroming which creates a lowpass filter stored
    %in lpslice. To create a high pass filter, every comp slice is divided by the
    %corrosponding lpslice and the value is assigned to hpcomp.
    for imageN = 1:4
        lpslice = ifft2(fft2(comp(:,:,200,imageN)).*filter);
        hpcomp(:,:,imageN, filtersize) = comp(:,:,200,imageN)./lpslice;
    end

    % Applying the inverse of the euler equation we get phase again. 
    hpphase = angle(hpcomp);

    %% Calculating the phaseMask
    % Preallocation

    %phaseMask = zeros(magSizeX, magSizeY, magSizeZ);

    % Rescaling all values between -pi and 0 to 0 to 1. Everything above 0 is set to 1.
    phaseMask = hpphase/pi + 1; phaseMask(phaseMask > 1) = 1;

    %% Creating the SWI

    %Preallocations
    %volSwi = zeros(magSizeX, magSizeY, magSizeZ); volMin = zeros(magSizeX, magSizeY, magSizeZ/4); volMean = zeros(magSizeX, magSizeY, magSizeZ/4); volMax = zeros(magSizeX, magSizeY, magSizeZ/4);

    %phaseMask ^4 then multiplying it by the magnitude image. 4 comes from
    %Hacke et al's original paper.

    volSwi = phaseMask.^4.*mag;
end

vol.swi = volSwi;
vol.min = volMin;
vol.max = volMax;
vol.mean = volMean;
vol.mag = mag;