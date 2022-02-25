function S = readSolienseFit(filename)

% Read Soliense LIFT data files containing fluorescence transient fit
% parameters. 
%
% INPUT
% filename = the filename and pathway of data file to read. 
% OUTPUT
% S = struct of fitted parameters. 
% The data will also be saved to your computer as a .mat file under the same
% and location as the original csv file. If readsoliense is called multiple
% times the .mat file will be rewritten. This saved data is also quality
% controlled to only include data with SNR > 5. 
%===============================================================================

fileread = readtable(filename);

S = struct();

% quality control
fieldnames = fileread.Properties.VariableNames;
oldsnr = contains(fieldnames,'S_N_RAT'); % recent software change, snr header not consistent anymore.
fileread.Properties.VariableNames(oldsnr) = {'SNR_raw'};
keep = fileread.SNR_raw > 5;

%save UTC time stamp and date of data points as a date number
S.mdate = datenum(fileread.DATE(keep)) + datenum(fileread.TIME(keep));
S.DC_light = sum([fileread.Light_1(keep), fileread.Light_2(keep), fileread.Light_3(keep), fileread.Light_4(keep), fileread.Light_5(keep)], 2);

%only keep variables of interest...i.e. fit values. leave out PIF etc. 
for i = 16:55
    
    field = fileread.Properties.VariableNames{i}; 
    S.(field) = fileread.(field)(keep);
    
end

%create new .mat file with same name as original csv file that saves all
%the wanted data. Return a struct with the same data. 
newfile = strrep(filename, '.csv','');
newfile = [newfile '.mat'];
save(newfile, '-struct', 'S')

end