function [ signal, signal2 ] = importCoincidences(  )
%IMPORTCOINCIDENCES Imports coincidence files from .txt files
%coincidence files saved as arrays in ns
%also removes tau=0 offset (with offsets found by inspection)

% signal: import delays files for 1000nm emitter:
fid_signal = fopen('46_35_NIR_1100SPF_1hour_Delays_Ch0 - Ch1_Ch0 - Ch1.txt'); % enter name of text file
signal = textscan(fid_signal, '%f');
signal = cell2mat(signal)/1000; %convert from ps to ns
fclose(fid_signal);
%offset for real tau = 0 found by inspection (comparing peaks to 12.5ns
%pulses)
signal = signal - 3.5;

% signal2: import delays files for 870nm emitter
fid_signal2 = fopen('g2_fucking_awesome_Delays_Ch0 - Ch1_Delays.txt'); % enter name of text file
signal2 = textscan(fid_signal2, '%f');
signal2 = cell2mat(signal2)/1000; %convert from ps to ns
fclose(fid_signal2);
%again, offset from tau = 0 found by inspection:
signal2 = signal2 - 0;


end

