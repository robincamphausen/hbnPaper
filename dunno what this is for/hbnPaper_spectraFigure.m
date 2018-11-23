close all

spectrum1000 = csvread('Pump 680 (SHG) Power 1.8mW table 60sec Int Time.csv');
spectrum860 = csvread('2x_850LP_plus_950LP_On_Emitter_10sec.csv');
% ST945 = spectrum1000(:,1)<945;
% spectrum1000(ST945,:) = [];
ST810 = spectrum860(:,1)<810 | spectrum860(:,1)>960;
spectrum860(ST810,:) =[];

PL860 = spectrum860(:,2);
PL860 = (PL860-min(PL860))/(max(PL860)-min(PL860));
WL860 = spectrum860(:,1);
PL1000 = spectrum1000(:,2);
PL1000 = (PL1000-min(PL1000))/(max(PL1000)-min(PL1000));
WL1000 = spectrum1000(:,1);
figure(4)
hold on
% plot(spectrum1000(:,1),spectrum1000(:,2)/max(spectrum1000(:,2)),'.',...
%     'Color', 0.7-3.5*[0.1 0.1 0],'LineWidth',0.1)
% plot(spectrum860(:,1),spectrum860(:,2)/max(spectrum860(:,2)),'.',...
%     'Color', 0.7-3.5*[0 0.1 0.1],'LineWidth',0.1)
plot(WL1000,PL1000,'r.')
plot(WL860,PL860,'.')
xlim([810 1050])
hXLabel = xlabel('Wavelength(nm)');
hYLabel = ylabel('PL intensity (a.u.)');

%Make the graph look good:
% Adjust font
set(gca, 'FontName', 'Helvetica')
set([hXLabel, hYLabel], 'FontName', 'Helvetica')
% set([hLegend, gca], 'FontSize', 8)
set([hXLabel, hYLabel], 'FontSize', 12)
% set(hTitle, 'FontSize', 12, 'FontWeight' , 'bold')

% Adjust axes properties
set(gca, 'Box', 'on', 'TickDir', 'out', 'TickLength', [.005 .005], ...
    'XMinorTick', 'off', 'YMinorTick', 'off', 'YGrid', 'off', ...
    'XColor', 0.3-[.3 .3 .3], 'YColor', 0.3-[.3 .3 .3], 'YTick', 0:0.1:1, ...
    'XTick',810:60:1050,...
    'LineWidth', 1)
set(gcf, 'PaperPositionMode', 'auto');
% PL860 = spectrum860(:,2);
% WL860 = spectrum860(:,1);
% PL1000 = spectrum1000(:,2);
% WL1000 = spectrum1000(:,1);
averagingFactor = 10;
for counter860 = 1:ceil(length(PL860)/averagingFactor)
    if counter860 == ceil(length(PL860)/averagingFactor)
        continue
%         PL860mean(counter860) = [];
%         WL860mean(counter860) = [];
    else
        PL860mean(counter860) = mean(PL860(averagingFactor*(counter860-1)+1:averagingFactor*counter860));
        WL860mean(counter860) = WL860(averagingFactor*counter860-2);
    end
end
for counter1000 = 1:ceil(length(PL1000)/averagingFactor)
    if counter1000 == ceil(length(PL1000)/averagingFactor)
        continue
%         PL1000mean(counter1000) = [];
%         WL1000mean(counter1000) = [];
    else
        PL1000mean(counter1000) = mean(PL1000(averagingFactor*(counter1000-1)+1:averagingFactor*counter1000));
        WL1000mean(counter1000) = WL1000(averagingFactor*counter1000-2);
    end
end
% figure(5)
% hold on
% plot(WL860mean,PL860mean,'b')
% plot(WL1000mean,PL1000mean,'r')