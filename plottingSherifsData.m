clear all
close all

% PL plot
% -----------------------------------------------
sherifsTheory = tdfread('Theory_PL.tsv', 'tab');
eV = sherifsTheory.energy;
PL = sherifsTheory.PL;

figTheory = figure(1);
PLplot = subplot(5,8,[1:4,9:12,17:20,25:28]);
plot(eV-0.71,PL,'r','LineWidth',1)

figTheory.Units = 'centimeters';
figTheory.Position = ([20 7 15 9]);
PLxlabel = xlabel('Photon Energy (eV)');
PLylabel = ylabel('PL (a.u.)');

% HR plot
% --------------------------------------------------------
HRplot = subplot(5,8,[6:8,14:16,22:24,30:32]);
yyaxis left
HRxlabel = xlabel('Phonon Energy (meV)');
HRylabel_L = ylabel('S (1/eV)');

yyaxis right
HRylabel_R = ylabel('S_k');
% --------------------------------------------------------
% set plot properties:
PLplot.FontName = 'Helvetica';
set(PLplot, 'Box', 'on', 'TickDir', 'out', 'TickLength', [.01 .01], ...
    'XMinorTick', 'off', 'YMinorTick', 'off', 'YGrid', 'off','YMinorGrid', 'off', ...
    'XColor', 0.3-[.3 .3 .3], 'YColor', 0.3-[.3 .3 .3],'Xdir', 'reverse',...
    'xlim', [0.9 1.3], 'YTick',0:0.5:1)
set(HRplot, 'Box', 'on', 'TickDir', 'out', 'TickLength', [.01 .01], ...
    'XMinorTick', 'off', 'YMinorTick', 'off', 'YGrid', 'off','YMinorGrid', 'off', ...
    'XColor', 0.3-[.3 .3 .3], 'YColor', 0.3-[.3 .3 .3],...
    'xlim', [0 300],'ylim', [0 50], 'YTick',0:10:50)
set([PLxlabel, PLylabel,HRxlabel, HRylabel_L], 'FontName', 'Helvetica','FontSize', 10)
% export_fig C:\Users\Robin\Documents\Writing\Papers\nir-single-photons-hBN\plots_and_figures\PLtheory.png -transparent -m21
