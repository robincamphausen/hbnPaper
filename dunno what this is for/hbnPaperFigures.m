% Plots g(2) for emitters at 870nm and at 1000nm
clear all
close all

%global plotting parameters
coincsmall =0.5;
coinc_range =80;

% signal: import delays files for 1000nm emitter:
fid_signal = fopen('46_35_NIR_1100SPF_1hour_Delays_Ch0 - Ch1_Ch0 - Ch1.txt'); % enter name of text file
signal = textscan(fid_signal, '%f');
signal = cell2mat(signal)/1000;
fclose(fid_signal);

% plot with large coinc bins to find offsets from tau = 0
coinc_window = 2.5 ; %in ns
edges = -coinc_range:coinc_window:coinc_range;
bin_centres = edges+coinc_window/2;
bin_centres(end) = [];
[signalCoinc, edges] = histcounts(signal,edges);

figure(1)
plot(bin_centres,signalCoinc);
title('Signal Coincidences');
xlabel('\tau (ns)');

% find real zero tau
minSignalCoinc = signalCoinc == min(signalCoinc);
% signal = signal - bin_centres(minSignalCoinc);
signal = signal - 3.5;

% now plot with small coinc bins
coinc_window = coincsmall ; %in ns
edges = -coinc_range:coinc_window:coinc_range;
bin_centres = edges+coinc_window/2;
bin_centres(end) = [];
[signalCoinc, edges] = histcounts(signal,edges);
% [backgroundCoinc, edges] = histcounts(background,edges);
% signalCoincPeaks = [981, 1088, 1110, 1062, 1162, 1189, 1111, 1083, 1126, 1064, 1042, 1002];
signalCoincPeaks = [1088, 1110, 1062, 1162, 1189, 1111, 1083, 1126, 1064, 1042];
norm = min(signalCoincPeaks)
%normalise to obtain g(2)
signalCoinc = signalCoinc/norm;

%make reference lines for g(2) = 0.5 and g(2) = 1
g1line = ones(1,length(bin_centres));
g05line = 0.5*g1line;
%plot g(2) for 1000nm emitter
figure(2)
plot(bin_centres,signalCoinc, 'k',bin_centres, g05line, '--k',bin_centres, g1line, '--k');
title('Signal Coincidences');
xlabel('\tau (ns)');

%-------------------------------------------------------------------------

% signal2: import delays files for 870nm emitter
fid_signal2 = fopen('g2_fucking_awesome_Delays_Ch0 - Ch1_Delays.txt'); % enter name of text file
signal2 = textscan(fid_signal2, '%f');
signal2 = cell2mat(signal2)/1000;
fclose(fid_signal2);

% plot with large coinc bins to find offsets from tau = 0
coinc_window = 2.5 ; %in ns
edges = -coinc_range:coinc_window:coinc_range;
bin_centres = edges+coinc_window/2;
bin_centres(end) = [];
[signal2Coinc, edges] = histcounts(signal2,edges);

figure(1)
hold on
plot(bin_centres,signal2Coinc);
title('Signal Coincidences');
xlabel('\tau (ns)');

% find real zero
minSignalCoinc = signal2Coinc == min(signal2Coinc);
% signal2 = signal2 - bin_centres(minSignalCoinc);
signal2 = signal2 - 0;

coinc_window = coincsmall ; %in ns
% coinc_range = 80; %in ns

edges = -coinc_range:coinc_window:coinc_range;
bin_centres = edges+coinc_window/2;
bin_centres(end) = [];
[signal2Coinc, edges] = histcounts(signal2,edges);
% [backgroundCoinc, edges] = histcounts(background,edges);
signal2CoincPeaks = [1079, 1010, 1139, 1184, 1091,1151, 1122, 1093, 1113, 1089, 1073, 1076];
norm2 = min(signal2CoincPeaks);
signal2Coinc = signal2Coinc/norm2;

figure(2)
hold on
plot(bin_centres,signal2Coinc+0.5, 'k');
% title('Signal Coincidences');
xlabel('\tau (ns)');
ylabel('g^{(2)}');
% xlim([-70 70])
set(gca,'ytick',0:2); 
ylim([0 2])

% figure(3)
hold on
xspacing = 0.1;
x = -125:xspacing:125;
lifetime = 4.5;
lifetime2 = 4;
decay = zeros(1,length(x));
decay2 = decay;
for counter = 1:21
    currentPeak = 125-counter*12.5;
    decayFalling = exp(-(x-currentPeak)/lifetime);
    onlyLT1_Falling = decayFalling >1;
    decayFalling(onlyLT1_Falling)=0;
    decayRising = exp((x-currentPeak)/lifetime);
    onlyLT1_Rising = decayRising >=1;
    decayRising(onlyLT1_Rising)=0;
    if currentPeak==0
        decay2 = decay2+decayFalling;
        decay2 = decay2+decayRising;
        continue
    end
    decay = decay+decayFalling;
    decay2 = decay2+2*decayFalling;
    decay = decay+decayRising;
    decay2 = decay2+2*decayRising;
end
firstpeak = x ==12.5;
decay = decay/decay(firstpeak);
decay2 = decay2/decay2(firstpeak) +0.5;
plot(x,decay,'b', x, decay2,'r')
xlim([-70 70])