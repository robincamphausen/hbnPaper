% hBN paper figure: Spectrum and Confocal map

close all
clear all

%set up subfig parameters
subfigrows = 10;
subfigcols = 30;
confocalCoords = zeros(1,subfigrows^2);
spectraWidth = subfigcols-subfigrows-5;
spectraCoords = zeros(1,subfigrows*spectraWidth);
for subfigcounter = 1:subfigrows
    confocalCoords((subfigcounter-1)*subfigrows+1 : subfigcounter*subfigrows) = ...
        (subfigcounter-1)*subfigcols+1 : (subfigcounter-1)*subfigcols+subfigrows;
    spectraCoords((subfigcounter-1)*spectraWidth+1 : subfigcounter*spectraWidth) =...
        (subfigcounter)*subfigcols-spectraWidth+1 : subfigcounter*subfigcols;
end

%Spectrum
% =========================================================================
% import spectral data
spectrum1000 = csvread('Pump 680 (SHG) Power 1.8mW table 60sec Int Time.csv');
spectrum860 = csvread('2x_850LP_plus_950LP_On_Emitter_10sec.csv');
ST810 = spectrum860(:,1)<810 | spectrum860(:,1)>960;
spectrum860(ST810,:) =[];

% normalise spectrum
PL860 = spectrum860(:,2);
PL860 = (PL860-min(PL860))/(max(PL860)-min(PL860));
WL860 = spectrum860(:,1);
PL1000 = spectrum1000(:,2);
PL1000 = (PL1000-min(PL1000))/(max(PL1000)-min(PL1000));
WL1000 = spectrum1000(:,1);
% plot spectrum
figure(4)
spectraplot = subplot(subfigrows,subfigcols,spectraCoords);
hold off
hold on
plot(WL1000,PL1000,'r.','markers',4)
plot(WL860,PL860,'.b','markers',4)
pbaspect([spectraWidth subfigrows 1])
xlim([810 1050])
hXLabel = xlabel('Wavelength (nm)');
hYLabel = ylabel('PL intensity (a.u.)');
xt = get(spectraplot, 'XTick');
set(spectraplot, 'FontSize', 8)

% Confocal map
% =========================================================================
fig4 = figure(4);
hold off
% position([200 200 500 300])
% confocal = imread('forMatlab_160630_121033_Channel1_Z1.ImageJ.bmp');
confocal = imread('forMatlabWithBackgroundSub_160630_121033_Channel1_Z1.bmp');
confocal = double(confocal);
LC = length(confocal(1,:));
% confocal = confocal(1:ceil(3*LC/5),1:ceil(3*LC/5));
confocal = confocal(floor(LC/4):ceil(3*LC/4),floor(LC/4):ceil(3*LC/4));
confocal = (confocal-min(min(confocal)))/(max(max(confocal))-min(min(confocal)));
confocalplot = subplot(subfigrows,subfigcols,confocalCoords);
image(confocal,'CDataMapping','scaled')
colormap('jet')
pbaspect([1 1 1])
cb =colorbar;
cb.Location = 'southoutside';
cb.Label.String = 'PL intensity (a.u.)';
cb.Ticks = [];
cb.Position = ([0.155 0.3 0.2 0.015]);
cb.Label.FontSize = 10;
cb.Label.FontName = 'Helvetica';
caxis([0.0 0.2]);
% grid off

%Make the graph look good:
% =========================================================================
% Adjust size
fig4.Units = 'centimeters';
fig4.Position = ([20 5 13 10]);

% Adjust font
set(spectraplot, 'FontName', 'Helvetica')
set([hXLabel, hYLabel], 'FontName', 'Helvetica')
% set([hLegend, gca], 'FontSize', 8)

set([hXLabel, hYLabel], 'FontSize', 10)
% set(hTitle, 'FontSize', 12, 'FontWeight' , 'bold')

% Adjust axes properties
set(spectraplot, 'Box', 'on', 'TickDir', 'out', 'TickLength', [.01 .01], ...
    'XMinorTick', 'off', 'YMinorTick', 'off', 'YGrid', 'off', ...
    'XColor', 0.3-[.3 .3 .3], 'YColor', 0.3-[.3 .3 .3], 'YTick', 0:0.5:1, ...
    'XTick',810:60:1050)
%     'LineWidth', 1)
set(confocalplot, 'Box', 'on', 'TickDir', 'out', 'TickLength', [0 0], ...
    'XMinorTick', 'off', 'YMinorTick', 'off', 'YGrid', 'off', ...
    'XColor', 0.3-[.3 .3 .3], 'YColor', 0.3-[.3 .3 .3], 'YTick', [], ...
    'XTick',[],...
    'LineWidth', 0.5)
% set(gcf, 'PaperPositionMode', 'auto');

%export_fig C:\Users\Robin\Documents\Writing\Papers\nir-single-photons-hBN\plots_and_figures\confocalSpectra.png -transparent -m21