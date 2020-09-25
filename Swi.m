
mag = niftiread('/Users/jonathan/Desktop/s_20200609_Gris7hjarna/Pig7mge3d.nii/MG/image004.nii');
phase = niftiread('/Users/jonathan/Desktop/s_20200609_Gris7hjarna/Pig7mge3d.nii/PH/image004.nii');
mag = rot90_3D(mag, 1, 1);
phase = rot90_3D(phase, 1, 1);

comp = mag.*exp(i*(phase + pi));


s = 512;
z = 512;

filter = hanning(70)*hanning(70)';

pad = (s-70)/2;

filter = padarray(filter, [pad pad]);

for o = 1:z
    lpslice = ifft2(fft2(comp(:,:,o)).*fftshift(filter));
    hpcomp(:,:,o) = comp(:,:,o)./lpslice;
end

hpphase = angle(hpcomp);

