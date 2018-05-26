clear all
close all

% PL plot
% -----------------------------------------------
sherifsTheory = tdfread('Theory_PL.tsv', 'tab');
eV = sherifsTheory.energy;
PL = sherifsTheory.PL;

figTheory = figure(1);
PLplot = subplot(5,8,[1:4,9:12,17:20,25:28]);
plot(eV-0.71,PL,'k','LineWidth',1);

figTheory.Units = 'centimeters';
figTheory.Position = ([20 7 15 9]);
PLxlabel = xlabel('Photon Energy (eV)');
PLylabel = ylabel('PL (a.u.)');

% HR plot
% --------------------------------------------------------
S_theory = tdfread('S_eV.tsv', 'tab');
meV_1 = 1000*S_theory.phononEnergy;
S = S_theory.S;

Sk_theory = tdfread('S_k.tsv', 'tab');
meV_2 = 1000*Sk_theory.phononEnergy;
Sk = Sk_theory.Sk;

HRplot = subplot(5,8,[6:8,14:16,22:24,30:32]);

[hAx,hLine1,hLine2] = plotyy(meV_1, S, meV_2,Sk);

HRxlabel = xlabel('Phonon Energy (meV)');
HRylabel_L = ylabel(hAx(1),'S (1/eV)','Color','k');
HRylabel_R = ylabel(hAx(2),'S_k','Color','k');

% --------------------------------------------------------
% set plot properties:
PLplot.FontName = 'Helvetica';
set(PLplot, 'Box', 'on', 'TickDir', 'out', 'TickLength', [.01 .01], ...
    'XMinorTick', 'off', 'YMinorTick', 'off', 'YGrid', 'off','YMinorGrid', 'off', ...
    'XColor', 0.3-[.3 .3 .3], 'YColor', 0.3-[.3 .3 .3],'Xdir', 'reverse',...
    'xlim', [0.9 1.3], 'YTick',0:0.5:1)
set(HRplot, 'Box', 'on', 'TickDir', 'out', 'TickLength', [.01 .01], ...
    'XMinorTick', 'off', 'YMinorTick', 'off', 'YGrid', 'off','YMinorGrid', 'off', ...
    'YColor', 'k','XTick',0:50:250)
set(hAx, 'xlim', [0 250],'xcolor','k');
set(hAx(1),'ylim', [0 50], 'YTick',0:10:50)
set(hAx(2),'ylim', [0 0.3], 'YTick',0:0.1:0.3,'ycolor','k')
set(hLine1,'LineWidth',1,'Color', 'k');
set(hLine2,'LineStyle','none','Marker','s','MarkerEdgeColor',[0.4 0.4 0.5],...
    'MarkerFaceColor',[0.4 0.4 0.5],'MarkerSize',2);
set([PLxlabel, PLylabel,HRxlabel, HRylabel_L], 'FontName', 'Helvetica','FontSize', 10,'Color','k')
% export_fig C:\Users\Robin\Documents\Writing\Papers\nir-single-photons-hBN\plots_and_figures\PLtheory.png -transparent -m21
