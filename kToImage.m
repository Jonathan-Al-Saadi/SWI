function vol = kToImage(kspacedata);

img_data =  ifftshift(fft(kspacedata.Spectrum,[],1),1);
img_data = ifftshift(fft(img_data,[],2),2);
img_data = sqrt(sum(abs(img_data).^2,4));
vol = abs(img_data);
