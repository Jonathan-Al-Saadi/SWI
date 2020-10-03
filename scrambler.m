function dirPath = scrambler(samplenumber)

%% Filling the name up to 20 digits, to make sure it is not recognized based on length.

%Calculating how long our sample is
samplenumberLength = length(samplenumber);

%pre allocating a row vector of 20
tmp = zeros(20,1)';

%Setting one part of the row vector to our samplenumber
startPlace = randi(5);

tmp(startPlace:(samplenumberLength+startPlace-1)) = samplenumber; %Putting it in a random place in the row vector

%Filling the rest with random integers
for ii = 1:startPlace-1
    tmp(ii) = randi(200) + 100;
end

for ii = samplenumberLength+startPlace:20
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
scrambleName = ceasar(tmp, encryptionkey);

%Removing / to make sure there will be no subfolders.
dirPath = sprintf('Animal%d', randi(1000000));

% Making the directory and adding the encryption key in a file there.
mkdir(dirPath); cd(dirPath);
fid = fopen( 'key.txt', 'wt' );
fprintf(fid, 'Original name: %s\n Encryption Key: %f\n Where in the string your number is: %f - %f\n', scrambleName, encryptionkey, startPlace, startPlace+samplenumberLength-1);
cd('..');
