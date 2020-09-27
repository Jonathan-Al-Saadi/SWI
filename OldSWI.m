function swiVol = niftiToSwi(volP, volM)

%% Reading the phase images and the magnitude images
%If the user does not specify any data, the fuction will call niftiRead
%which reads all the nifti-files in a directory and stores the data in a
%4D-matrix.
if nargin == 0
    waitfor(msgbox('Choose phase images directory'));
    volP = niftiRead();
    waitfor(msgbox('Choose magnitude images directory'));
    volM = niftiRead();
end

%% Creating a phase mask
%Uses the filtered? phase image and converts it to a phase mask. 
f = waitbar(0, 'Rescaling the phase images');
[x, y, z, n] = size(volP);
for ii = 1:n
    volP(:,:,:,ii) = rescale(volP(:,:,:,ii));
    waitbar(ii/n, f, strcat('Rescaling phase image: %f', ii));
end
close(f);



%% Creating SWI-images
%Multiplying the phase mask with the magnitude image four times.

swiVol = zeros(x,y,z,n); %Pre-allocating space for swiVol

f = waitbar(0, 'Calculating SWI');
for ii = 1:n
    swiVol(:,:,:,ii) = volP(:,:,:,ii) .* volM(:,:,:,ii);
    waitbar(ii/n, f);
end
close(f);
