% Plots g(2) and tau for emitter at 1000nm
%------------------------------------------------------------------------------------------------------
clear all
close all

%global plotting parameters
coinc_window =0.5;
coinc_range =70;

% signal: import delays files for emitters:
[ signal_1000, signal_870 ] = importCoincidences(  ); %import delays
signal = signal_1000;

% now plot with coinc bins
edges = -coinc_range-coinc_window/2:coinc_window:coinc_range+coinc_window/2;
bin_centres = edges+coinc_window/2;
bin_centres(end) = [];
[signalCoinc, edges] = histcounts(signal,edges);
signalCoincPeaks = [1088, 1110, 1062, 1162, 1189, 1111, 1083, 1126, 1064, 1042];
norm = min(signalCoincPeaks);
%norm = mean(signalCoincPeaks);
%normalise to obtain g(2)
signalCoinc = signalCoinc/norm;

%plot g(2) for 1000nm emitter
figure(1)
fig1 = figure(1);
g2plot = subplot(11,7,1:35);
hold on
plot(bin_centres,signalCoinc, 'k.');
hXLabel = xlabel('Delay (ns)');
hYLabel = ylabel('g^{(2)}(\tau)');
set(gca,'ytick',0:0.5:1.5); 
ylim([-0.05 1.3])

%Export 1000nm experimental g2 data
%g2_1000nm_exp(1,:) = bin_centres;
%g2_1000nm_exp(2,:) = signalCoinc;
%csvwrite('g2_1000nm_exp.csv',g2_1000nm_exp);
%------------------------------------------------------------------------------------------------------

fig1title = title('g^{(2)} fitting with autocorr method, \tau = 5.5ns');
%fig1title = title('g^{(2)} fitting with photon sampling method, \tau = 5.5s');


%import simulated g2 values (check filenames):

%for autocorr method:
decay = csvread('g2_1000_1photon_5.4ns.csv');
decayTauList_jup = csvread('taulistJupyter.csv');
% import single (fitting) peak:
singlepeak1000 = csvread('singlepulseAutocorr_1000_1photon_5.4ns.csv');


%for photon sampling method:
%decayStruct = load('singlePhoton_tauDecay1_5.5ns.mat','y_hist');
% decayLoad = decayStruct.y_hist;
% decay = decayLoad/(max(decayLoad));
% decayTauListStruct = load('singlePhoton_tauDecay1_5.5ns.mat', 'bins');
% decayTauListLoad = decayTauListStruct.bins;
% decayTauListLoad = decayTauListLoad(2)-decayTauListLoad(1)+decayTauListLoad;
% decayTauList = decayTauListLoad(1:end-1);
decayTauList = decayTauList_jup;


%define background
background = csvread('g2_1000_classical_5.4ns.csv');

subplot(11,7,1:35);
p1 = plot(decayTauList,decay,'r','LineWidth',1);
p2 = plot(decayTauList,0.4*background+0.6*decay,'b','LineWidth',1);
xlim([-coinc_range coinc_range])

% -------------------------------------------------------------------------
% Lifetime

% Import exponential peaks

decayCurve_1000 = csvread('decay1000_fullPeak.csv');

stats(1,:) = mean(decayCurve_1000);
stats(2,:) = std(decayCurve_1000);

% normalise decay curves:
decayCurve_1000 = decayCurve_1000/max(stats(1,:));
%------------------------------------------------------------------------------------------------------

% plot 1000nm decay peak with fitting
% -----------------------------------
tau1000Coords = [50:77];
tau1000 = subplot(11,7,tau1000Coords);

coincWinsPerLaserT = 12.5/coinc_window;
highestTau = (floor(coincWinsPerLaserT/2))*coinc_window;
decayTau = -highestTau:coinc_window:highestTau;

hold on
for decay1000counter = 1:length(decayCurve_1000(:,1))
    plot(decayTau,decayCurve_1000(decay1000counter,:),'.k')
end
taufit1000 = plot(decayTauList_jup, singlepeak1000,'r','LineWidth',1);
xlim([-3 3])
ylim([0.4 1.1])
hXLabel2 = xlabel('Delay (ns)');
hYLabel2 = ylabel('PL (a.u.)');
%set(tau1000, 'YScale', 'log');
hlegend2 = legend(taufit1000,'\tau_{1.24eV} = 5.5ns');



% make graph pretty
% =========================================================================

fig1.Units = 'centimeters';
fig1.Position = ([20 7 13 10]);

g2plot.FontSize = 10;
g2plot.FontName = 'Helvetica';
set(g2plot, 'Box', 'on', 'TickDir', 'out', 'TickLength', [.01 .01], ...
    'XMinorTick', 'off', 'YMinorTick', 'off', 'YGrid', 'on','YMinorGrid', 'off', ...
    'XColor', 0.3-[.3 .3 .3], 'YColor', 0.3-[.3 .3 .3])

set([hXLabel, hYLabel], 'FontName', 'Helvetica')
%set(hLegend, 'FontSize', 7)
set([hXLabel, hYLabel], 'FontSize', 10)

% Adjust axes properties
set(tau1000, 'Box', 'on', 'TickDir', 'out', 'TickLength', [.02 .02], ...
    'XMinorTick', 'off', 'YMinorTick', 'off', 'YGrid', 'on','YMinorGrid', 'on', ...
    'XColor', 0.3-[.3 .3 .3], 'YColor', 0.3-[.3 .3 .3], 'YTick', 0:0.5: 1,'XTick', -3:1: 3, ...
    'FontName', 'Helvetica', 'FontSize', 7 ...
    )
set([hXLabel2, hYLabel2, hlegend2], 'FontSize', 10)
set(hlegend2, 'Location','southwest', 'Box', 'on')
%set([hXLabel2, hYLabel2,hXLabel3, hYLabel3], 'FontSize', 10)
%set([hlegend2, hlegend3], 'Location','southwest', 'Box', 'on')


% export_fig C:\Users\Robin\Documents\Writing\Papers\nir-single-photons-hBN\plots_and_figures\g2_tau_only1000_autocorr5.5.png -transparent -m8
% export_fig C:\Users\Robin\Documents\Writing\Papers\nir-single-photons-hBN\plots_and_figures\g2_tau_only1000_autocorr10.png -transparent -m8
%export_fig C:\Users\Robin\Documents\Writing\Papers\nir-single-photons-hBN\plots_and_figures\g2_tau_only1000_photonSampling5.5.png -transparent -m8
% export_fig C:\Users\Robin\Documents\Writing\Papers\nir-single-photons-hBN\plots_and_figures\g2_tau_only1000_photonSampling10.png -transparent -m8