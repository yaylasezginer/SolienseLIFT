
function  [a,count] = cat_uwdata(filedir,datatype)

% 1. loop through file directories.
% 2. open files of the specified datatype (underway or discrete)
% 3. Create a stuct containing all the data
% INPUT
% filedir = path containing files to be read
% datatype = 'uw' for rapid underway data or 'discrete' for PI or dark
% acclimation curves
% OUTPUT
% a = concatenated data structure
% count = number of datafiles concatenated. 
%
% y.s. Updated Feb 15, 2022
%========================================================================

folders = dir(filedir); %open folder containing all underway data folders
TF = isfolder({folders.name}); %don't loop through anything that is not a folder 
datafolders = {folders(~TF).name}; %List of daily folders created containing uw data

count = 0;

dt = contains(datatype,'uw');
switch dt
    case 0
        strmatch1 = 'discrete_fit';
        strmatch2 = 'REPROCESSED_fit';
    case 1
        strmatch1 = 'Amund21_fit';
        strmatch2 = 'Amund2021_fit';
end

%Loop through each daily folder to read in the data files.

for i = 1:numel(datafolders)
    
    %open daily folder
    dailyfolder = dir([filedir '/' datafolders{i}]);
    
    % if data hasn't been read before call readSoliense to create a .mat file, otherwise read the existing .mat file
    newread = any(contains({dailyfolder.name},'.mat'));
    filetype = [{'.csv'},{'.mat'}];
    
    %Identify the possible variations of underway file you want
    fitfile1 = contains({dailyfolder.name},[strmatch1 filetype{newread+1}]);
    fitfile2 = contains({dailyfolder.name},[strmatch2 filetype{newread+1}]);
    fitfile = any([fitfile1; fitfile2]);
    
    for j = 1:sum(fitfile)
        count = count + 1; % count how many files are concatenated
        
        ind = find(fitfile);
        filename = [filedir '/' datafolders{i} '/' dailyfolder(ind(j)).name];
        
        switch newread
           case 0
        S = readSolienseFit(filename);
           case 1
        S = load(filename);
        end
        
        var = fieldnames(S);
        if count == 1
            a = S; %Start building data struct
        elseif count > 1   
        
        a_var = fieldnames(a);
        for k = 1:numel(var)
            fieldmatch = matches(a_var, var{k}); % be sure you're concatenating the same variables
            if sum(fieldmatch) == 1
            a.(a_var{fieldmatch}) = [a.(a_var{fieldmatch}); S.(var{k})];
            end
        end
        
        end
    end
    
end

end

