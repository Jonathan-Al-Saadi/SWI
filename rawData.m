function rawdata = rawData(datadir);

% addpath('/Users/peterdamberg/Documents/MATLAB/matNMR')

datadir='/Users/jonathan/Desktop/s_20200609_Gris7hjarna/mge3dPigBrain_nr_2020Jun10_0428s44_PH.img/slab001image001echo005.fdf'; 

rawprocpar= ReadParameterFile('/Users/jonathan/Desktop/s_20200609_Gris7hjarna/mge3dPigBrain_nr_2020Jun10_0428s44_PH.img/procpar');

%np=1024; number of real points in real dimension, i.e. 2*number of complex points
linenumber=strmatch('np ',rawprocpar)+1; temp=str2num(rawprocpar(linenumber,:));
np=temp(2:end);

%ne=12; number of echos
linenumber=strmatch('ne ',rawprocpar)+1; temp=str2num(rawprocpar(linenumber,:));
ne=temp(2:end);

%nv=512; number of gradient steps in phase encode direction
linenumber=strmatch('nv ',rawprocpar)+1; temp=str2num(rawprocpar(linenumber,:));
nv=temp(2:end);

%nv2=512 number of steps in second phase encode direction
linenumber=strmatch('nv2 ',rawprocpar)+1; temp=str2num(rawprocpar(linenumber,:));
nv2=temp(2:end);

%sw sweep width determines dwell time in read direction
linenumber=strmatch('sw ',rawprocpar)+1; temp=str2num(rawprocpar(linenumber,:));
sw=temp(2:end);

%lro length (Field-of-View) in cm in read direction
linenumber=strmatch('lro ',rawprocpar)+1; temp=str2num(rawprocpar(linenumber,:));
lro=temp(2:end);

%lpe length in cm in phase encode direction
linenumber=strmatch('lpe ',rawprocpar)+1; temp=str2num(rawprocpar(linenumber,:));
lpe=temp(2:end);

%lpe2 length in cm in second phase encode direction
linenumber=strmatch('lpe2 ',rawprocpar)+1; temp=str2num(rawprocpar(linenumber,:));
lpe2=temp(2:end);


linenumber=strmatch('TE ',rawprocpar)+1; temp=str2num(rawprocpar(linenumber,:));
tearray=temp(2:end); %array with the ne echo times


rawdata=matNMRReadBinaryFID(datadir,np/2*ne,nv*nv2,5,0,2);