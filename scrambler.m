function dirPath = scrambler(samplenumber)

%% Filling the name up to 20 digits, to make sure it is not recognized based on length.

%Calculating how long our sample is
samplenumberLength = length(samplenumber);

%pre allocating a row vector of 20
tmp = zeros(20,1)';

%Setting the first part of the row vector to our samplenumber
tmp(1:samplenumberLength) = samplenumber;

%Filling the rest with random integers
for ii = (samplenumberLength+1):length(tmp)
    tmp(ii) = randi(200) + 100;
end

%% Next we encrypt the name using ceasar.

% Setting a random encryption key.
encryptionkey = randi(100);

%Making sure the encryption key is not 95 (Will spin Ceasar around or 63
%which will capitilze)
if encryptionkey == 95 || encryptionkey == 63
    encryptionkey = encryptionkey + 1;
end

%Creating the pathname using ceasar
dirPath = ceasar(tmp, encryptionkey);
%Removing / to make sure there will be no subfolders.
dirPath(dirPath == '/') = ' ';

% Making the directory and adding the encryption key in a file there.
mkdir(dirPath); cd(dirPath);
fid = fopen( 'key.txt', 'wt' );
fprintf(fid, '%f\n', encryptionkey);
cd('..');
