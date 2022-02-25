# SolienseLIFT
Handle raw data and fitted data produced by Soliense LIFT Fast Repetition Rate Fluorometers

cat_uwdata.m calls readSolienseFit.m to concatenate multiple data files stored in a common local folder. 
readSolienseFit.m converts Soliense fit csv files to structs and saves .mat files to the same folder where original raw data files are stored. 
