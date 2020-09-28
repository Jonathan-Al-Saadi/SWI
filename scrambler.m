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

%Creating the pathname using ceasar
dirPath = ceasar(tmp, encryptionkey);
dirPath(dirPath == '/') = ' ';

% Making the directory and adding the encryption key in a file there.
mkdir(dirPath); cd(dirPath);
fid = fopen( 'key.txt', 'wt' );
fprintf(fid, '%f\n', encryptionkey);
cd('..');
