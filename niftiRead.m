function V = niftiRead(filePath)

%%
%Depending on what the user puts in
if nargin > 1
    error('Unrecognized input. Please enter filepath or nothing.')
end

%%
%Opens dialogbox for user to input file path, then counts the number of
%nifti files in that path
directory = uigetdir(); %Find the directory of the niftifiles
filePath = dir(directory); %Creating a string of the filePath for that directory
names = {filePath.name}; names = names(3:end); %Finding the names and removing the first 2 directories
nameArray = strcat(directory, '/', names); %Creating a name array of the directories

%%
%Preallocation
V = zeros([size(niftiread(char(nameArray(1)))), length(nameArray)]); %Reads the first file size and number of files and preallocates accordingly


%%
%Reading files and assigning them to a 4D matrix vol.
f = waitbar(0, 'Reading files...');
for ii = 1:length(nameArray)
    V(:,:,:,ii) = niftiread(char(nameArray(ii)));
    waitbar(ii/length(nameArray),f, strcat('Reading image number: ', ii));
end
close(f);
