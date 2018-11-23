% Plots g(2) for emitters at 870nm and at 1000nm
clear all
close all

%global plotting parameters
coincsmall =0.5;
coinc_range =70;

% signal: import delays files for 1000nm emitter:
fid_signal = fopen('46_35_NIR_1100SPF_1hour_Delays_Ch0 - Ch1_Ch0 - Ch1.txt'); % enter name of text file
signal = textscan(fid_signal, '%f');
signal = cell2mat(signal)/1000;
fclose(fid_signal);

%offset for real tau = 0 found by inspection (comparing peaks to 12.5ns
%pulses)
signal = signal - 3.5;

% now plot with small coinc bins
coinc_window = coincsmall ; %in ns
edges = -coinc_range-coinc_window/2:coinc_window:coinc_range+coinc_window/2;
bin_centres = edges+coinc_window/2;
bin_centres(end) = [];
[signalCoinc, edges] = histcounts(signal,edges);
% signalCoincPeaks = [981, 1088, 1110, 1062, 1162, 1189, 1111, 1083, 1126, 1064, 1042, 1002];
signalCoincPeaks = [1088, 1110, 1062, 1162, 1189, 1111, 1083, 1126, 1064, 1042];
norm = min(signalCoincPeaks);
% norm = mean(signalCoincPeaks);
%normalise to obtain g(2)
signalCoinc = signalCoinc/norm;

%make reference lines for g(2) = 0.5 and g(2) = 1
g1line = ones(1,length(bin_centres));
g00line = 0*g1line;
g05line = 0.5*g1line;
g15line = 1.5*g1line;
g20line = 2*g1line;
g25line = 2.5*g1line;
%plot g(2) for 1000nm emitter
figure(1)
hold on
plot(bin_centres,signalCoinc, 'k.')%,bin_centres, g05line, '--k',bin_centres, g1line, '--k');
plot(bin_centres, g00line, '--','Color', 0.6-[0.1 0.1 0.1])
plot(bin_centres, g05line, '--','Color', 0.6-[0.1 0.1 0.1])
plot(bin_centres, g1line, '--','Color', 0.6-[0.1 0.1 0.1])
plot(bin_centres, g15line, '--','Color', 0.6-[0.1 0.1 0.1])
plot(bin_centres, g20line, '--','Color', 0.6-[0.1 0.1 0.1])
plot(bin_centres, g25line, '--','Color', 0.6-[0.1 0.1 0.1])
% title('Second-order Coherence');
% xlabel('\tau (ns)');

%-------------------------------------------------------------------------

% signal2: import delays files for 870nm emitter
fid_signal2 = fopen('g2_fucking_awesome_Delays_Ch0 - Ch1_Delays.txt'); % enter name of text file
signal2 = textscan(fid_signal2, '%f');
signal2 = cell2mat(signal2)/1000;
fclose(fid_signal2);

%again, offset from tau = 0 found by inspection:
signal2 = signal2 - 0;

%plot with small coinc bins
[signal2Coinc, edges] = histcounts(signal2,edges);

%peaks found by inspection (for coinc bin = 0.5ns):
% signal2CoincPeaks = [1079, 1010, 1139, 1184, 1091,1151, 1122, 1093, 1113, 1089, 1073, 1076];
signal2CoincPeaks = [1010, 1139, 1184, 1091,1151, 1122, 1093, 1113, 1089, 1073];
norm2 = min(signal2CoincPeaks);
%normalise to obtain g(2)
signal2Coinc = signal2Coinc/norm2;

figure(1)
hold on
%plot 870nm vertically offset by 1 for visual clarity:
plot(bin_centres,signal2Coinc+1, 'k.');
% title('Signal Coincidences');
xlabel('Delay time (ns)');
ylabel('g^{(2)}(\tau)');
set(gca,'ytick',0:0.5:2.5); 
ylim([-0.05 2.55])

%--------------------------------------------------------------------------

%Plot inverse exponential fits:

hold on
xspacing = 0.1;
x = -125:xspacing:125;
% without background: lifetime1=5.5, lifetime2=4.7
lifetime1 = 5.1;
lifetime2=4.7;

% optimal with artificial background:
% lifetime1 = 2.5;
% lifetime2 = 3.9;

decay = zeros(1,length(x));
decay2 = decay;
for whichEmitter = 1:2
    for counter = 1:21
        currentPeak = 125-counter*12.5;
        
        if whichEmitter ==1
            lifetime = lifetime1;
        else
            lifetime = lifetime2;
        end
        
        decayFalling = exp(-(x-currentPeak)/lifetime);
        onlyLT1_Falling = decayFalling >1;
        decayFalling(onlyLT1_Falling)=0;

        decayRising = exp((x-currentPeak)/lifetime);
        onlyLT1_Rising = decayRising >=1;
        decayRising(onlyLT1_Rising)=0;

        if whichEmitter ==1
            if currentPeak==0
                continue
            end
            decay = decay+decayFalling;
            decay = decay+decayRising;
        else
            if currentPeak==0
                decay2 = decay2+decayFalling;
                decay2 = decay2+decayRising;
            else
                decay2 = decay2+2*decayFalling;
                decay2 = decay2+2*decayRising;
            end
        end
    end
end
firstpeak = x ==12.5;
% artificial background added decay+0.9, decay2+0.2
% decay = decay+0.9;
decay = decay/decay(firstpeak);
% decay2 = (decay2+0.2)/decay2(firstpeak) +0.5;
decay2 = (decay2)/decay2(firstpeak) +1;
p1 = plot(x,decay,'b','LineWidth',1);
p2 = plot(x, decay2,'r','LineWidth',1);
legend([p1 p2],{'YYY defect', 'XXX defect'},'Location','southeast')
xlim([-coinc_range coinc_range])