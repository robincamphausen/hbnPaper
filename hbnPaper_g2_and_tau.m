% Plots g(2) for emitters at 860nm and at 1000nm
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
g2plot = subplot(9,7,1:28);
hold on
plot(bin_centres,signalCoinc, 'k.')%,bin_centres, g05line, '--k',bin_centres, g1line, '--k');
% plot(bin_centres, g00line, '--','Color', 0.6-[0.1 0.1 0.1])
% plot(bin_centres, g05line, '--','Color', 0.6-[0.1 0.1 0.1])
% plot(bin_centres, g1line, '--','Color', 0.6-[0.1 0.1 0.1])
% plot(bin_centres, g15line, '--','Color', 0.6-[0.1 0.1 0.1])
% plot(bin_centres, g20line, '--','Color', 0.6-[0.1 0.1 0.1])
% plot(bin_centres, g25line, '--','Color', 0.6-[0.1 0.1 0.1])
% title('Second-order Coherence');
% xlabel('\tau (ns)');
g2_1000nm_exp(1,:) = bin_centres;
g2_1000nm_exp(2,:) = signalCoinc;
csvwrite('g2_1000nm_exp.csv',g2_1000nm_exp)

%-------------------------------------------------------------------------

% signal2: import delays files for 860nm emitter
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

hold on
%plot 860nm vertically offset by 1 for visual clarity:
plot(bin_centres,signal2Coinc+1, 'k.');
% title('Signal Coincidences');
hXLabel = xlabel('Delay (ns)');
hYLabel = ylabel('g^{(2)}(\tau)');
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
% figure(1)
% subplot(2,1,1)
firstpeak = x ==12.5;
% artificial background added decay+0.9, decay2+0.2
% decay = decay+0.9;
decay = decay/decay(firstpeak);
% decay2 = (decay2+0.2)/decay2(firstpeak) +0.5;
decay2 = (decay2)/decay2(firstpeak) +1;

decay = csvread('g2_1000_2photon.csv');
decay2 = csvread('g2_860_2photon.csv');
decayTauList = csvread('taulistJupyter.csv');
decay2 = decay2+1;

p1 = plot(decayTauList,decay,'r','LineWidth',1);
p2 = plot(decayTauList, decay2,'b','LineWidth',1);
hLegend = legend([p2 p1],{'1.44eV (860nm)','1.24eV (1\mum)'},'Location','southeast');
xlim([-coinc_range coinc_range])

% -------------------------------------------------------------------------
% Lifetime

%Finds decay lifetime for emitters by fitting negative exponential to
%experimental coincidence peak slopes
% clear all
% close all
lifetime1 = 5.6;
lifetime2 = 4.6;

[ signal_1000, signal_870 ] = importCoincidences(  ); %import delays

%bin coincidences:
coinc_range = 80; %make sure this is integer multiple of 12.5
coinc_window = 0.5; %in ns - make sure 12.5=N*coinc_window where N is integer
edges = -coinc_range-coinc_window/2:coinc_window:coinc_range+coinc_window/2;
bin_centres = edges+coinc_window/2;
bin_centres(end) = [];
bin_centres = round(bin_centres,2);
coinc_1000 = histcounts(signal_1000,edges);
coinc_870 = histcounts(signal_870,edges);
% figure(1)
% subplot(2,1,1)
% plot(bin_centres, coinc_1000, bin_centres, coinc_870)
% diff1000 = diff(coinc_1000);
% diff870 = diff(coinc_870);
% subplot(2,1,2)
% plot(bin_centres(1:end-1),diff1000, bin_centres(1:end-1),diff870)

coincWinsPerLaserT = 12.5/coinc_window;
highestTau = (floor(coincWinsPerLaserT/2))*coinc_window;
decayTau = -highestTau:coinc_window:highestTau;

% peaks(1,:) = [-75.5, -62.5, -50, -37.5, -25, -13, 12.5, 25, 37, 49.5, 62];%, 75];
peaks(1,:) = [-62.5, -50, -37.5, -25, -13, 12.5, 25, 37, 49.5, 62];%, 75];
% peaks(2,:) = [-74.5, -62.5, -50, -37, -24.5, -12.5, 13, 25.5, 37.5, 50, 62.5];%, 75];
peaks(2,:) = [-62.5, -50, -37, -24.5, -12.5, 13, 25.5, 37.5, 50, 62.5];%, 75];

for whichPeak = 1:length(peaks(1,:))
    for whichEmitter =1:2
        currentPeak = peaks(whichEmitter,whichPeak);
        grabTheseCoincs = bin_centres>=(currentPeak - highestTau) & ...
            bin_centres <= (currentPeak+highestTau);
        whichPeak
        if whichEmitter==1
%             decayCurve_1000(whichPeak,:) = ...
%                 coinc_1000(grabTheseCoincs)/max(coinc_1000(grabTheseCoincs));
            decayCurve_1000(whichPeak,:) = ...
                coinc_1000(grabTheseCoincs);
            
        else
%             decayCurve_870(whichPeak,:) = ...
%                 coinc_870(grabTheseCoincs)/max(coinc_870(grabTheseCoincs));
            decayCurve_870(whichPeak,:) = ...
                 coinc_870(grabTheseCoincs);


        end
    end
end


stats(3,:) = mean(decayCurve_1000);
stats(1,:) = mean(decayCurve_870);
stats(4,:) = std(decayCurve_1000);
stats(2,:) = std(decayCurve_870);

% csvwrite('decay1000_fullPeak.csv',decayCurve_1000)
% csvwrite('decay870_fullPeak.csv',decayCurve_870)
% csvwrite('decayStats.csv',stats)

% normalise decay curves:
decayCurve_870 = decayCurve_870/max(stats(1,:));
decayCurve_1000 = decayCurve_1000/max(stats(3,:));

% import fitting peaks (from jupyter)
singlepeak860 = csvread('singlepeak860.csv');
singlepeak1000 = csvread('singlepeak1000.csv');

fig1 = figure(1);
% plot 860nm decay peak with fitting
% ----------------------------------
tau860Coords = [36:38, 43:45, 50:52, 57:59];
tau860 = subplot(9,7,tau860Coords);
hold on
for decay860counter = 1:length(decayCurve_870(:,1))
    plot(decayTau,decayCurve_870(decay860counter,:),'.k')
end
% errorbar(decayTau,stats(1,:),stats(2,:),'o', 'MarkerFaceColor', 'b', 'MarkerSize',4)
% plot(decayTau, exp(-(decayTau)/lifetime1), 'b')
taufit860 = plot(decayTauList, singlepeak860,'b','LineWidth',1);
xlim([-3 3])
ylim([0.4 1.2])
hXLabel2 = xlabel('Delay (ns)');
hYLabel2 = ylabel('PL (a.u.)');
set(tau860, 'YScale', 'log')
hlegend2 = legend(taufit860, '\tau_{1.44eV} = 4.6ns');


% plot 1000nm decay peak with fitting
% -----------------------------------
tau1000Coords = [40:42, 47:49, 54:56, 61:63];
tau1000 = subplot(9,7,tau1000Coords);
hold on
for decay1000counter = 1:length(decayCurve_1000(:,1))
    plot(decayTau,decayCurve_1000(decay1000counter,:),'.k')
end
% errorbar(decayTau,stats(3,:),stats(4,:),'ro', 'MarkerFaceColor', 'r', 'MarkerSize',4)
taufit1000 = plot(decayTauList, singlepeak1000,'r','LineWidth',1);
xlim([-3 3])
ylim([0.4 1.2])
hXLabel3 = xlabel('Delay (ns)');
hYLabel3 = ylabel('PL (a.u.)');
set(tau1000, 'YScale', 'log');
hlegend3 = legend(taufit1000,'\tau_{1.24eV} = 5.6ns');



% make graph pretty
% =========================================================================

fig1.Units = 'centimeters';
fig1.Position = ([20 7 13 10]);

g2plot.FontSize = 8;
g2plot.FontName = 'Helvetica';
set(g2plot, 'Box', 'on', 'TickDir', 'out', 'TickLength', [.01 .01], ...
    'XMinorTick', 'off', 'YMinorTick', 'off', 'YGrid', 'on','YMinorGrid', 'off', ...
    'XColor', 0.3-[.3 .3 .3], 'YColor', 0.3-[.3 .3 .3])

set([hXLabel, hYLabel], 'FontName', 'Helvetica')
set(hLegend, 'FontSize', 7)
set([hXLabel, hYLabel], 'FontSize', 10)

% Adjust axes properties
set([tau860 tau1000], 'Box', 'on', 'TickDir', 'out', 'TickLength', [.02 .02], ...
    'XMinorTick', 'off', 'YMinorTick', 'off', 'YGrid', 'on','YMinorGrid', 'on', ...
    'XColor', 0.3-[.3 .3 .3], 'YColor', 0.3-[.3 .3 .3], 'YTick', 0:0.5: 1,'XTick', -3:1: 3, ...
    'FontName', 'Helvetica', 'FontSize', 7 ...
    )
set([hXLabel2, hYLabel2,hXLabel3, hYLabel3], 'FontSize', 10)
set([hlegend2, hlegend3], 'Location','southwest', 'Box', 'on')

% export_fig C:\Users\Robin\Documents\Writing\Papers\nir-single-photons-hBN\plots_and_figures\g2_tau.png -transparent -m21


% set(gca, 'FontName', 'Helvetica')
% set([hXLabel2, hYLabel], 'FontName', 'Helvetica')
% % set([hLegend, gca], 'FontSize', 8)
% set([hXLabel2, hYLabel], 'FontSize', 10)
% set(hTitle, 'FontSize', 12, 'FontWeight' , 'bold')

% % Adjust axes properties
% set(gca, 'Box', 'on', 'TickDir', 'out', 'TickLength', [.005 .005], ...
%     'XMinorTick', 'off', 'YMinorTick', 'off', 'YGrid', 'off', ...
%     'XColor', 0.3-[.3 .3 .3], 'YColor', 0.3-[.3 .3 .3] ...
%     )
% % set(gcf, 'PaperPositionMode', 'auto');




% 
% for whichPeakAgain = 1:length(decayCurve_1000(:,1))
%     figure(2)
%     subplot(1,2,1)
%     hold on
%     plot(decayTau,decayCurve_1000(whichPeakAgain,:), 'bo')
%     subplot(1,2,2)
%     hold on
%     plot(decayTau,decayCurve_870(whichPeakAgain,:), 'ro')
% end
% subplot(1,2,1)
% plot(decayTau, exp(-(decayTau)/lifetime1), 'b')
% subplot(1,2,2)
% plot(decayTau, exp(-(decayTau)/lifetime2), 'r')
