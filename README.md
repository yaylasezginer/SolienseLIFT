# SolienseLIFT
Handle raw data and fitted data produced by Soliense LIFT Fast Repetition Rate Fluorometers

readSolienseFit.m converts Soliense fit csv files to structs and saves .mat files to the same folder where original raw data files are stored. 

cat_uwdata.m calls readSolienseFit.m to concatenate multiple data files stored in a common local folder. cat_uw was originally written to concatenate daily data files collected during a research cruise, and to distinguish between data that was collected continuously underway and data collected from discrete sample analysis.  
