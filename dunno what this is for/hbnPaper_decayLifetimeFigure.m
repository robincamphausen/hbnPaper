%Finds decay lifetime for emitters by fitting negative exponential to
%experimental coincidence peak slopes
clear all
close all
lifetime1 = 5;
lifetime2 = 4.7;

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
decayTau = 0:coinc_window:highestTau;

peaks(1,:) = [-75.5, -62.5, -50, -37.5, -25, -13, 12.5, 25, 37, 49.5, 62];%, 75];
peaks(2,:) = [-74.5, -62.5, -50, -37, -24.5, -12.5, 13, 25.5, 37.5, 50, 62.5];%, 75];

for whichPeak = 1:length(peaks(1,:))
    for whichEmitter =1:2
        currentPeak = peaks(whichEmitter,whichPeak);
        grabTheseCoincs = bin_centres>=currentPeak & ...
            bin_centres <= (currentPeak+highestTau);
        whichPeak
        if whichEmitter==1
            decayCurve_1000(whichPeak,:) = ...
                coinc_1000(grabTheseCoincs)/max(coinc_1000(grabTheseCoincs));
        else
            decayCurve_870(whichPeak,:) = ...
                coinc_870(grabTheseCoincs)/max(coinc_870(grabTheseCoincs));
        end
    end
end


for whichPeakAgain = 1:length(decayCurve_1000(:,1))
    figure(2)
    subplot(1,2,1)
    hold on
    plot(decayTau,decayCurve_1000(whichPeakAgain,:), 'bo')
    subplot(1,2,2)
    hold on
    plot(decayTau,decayCurve_870(whichPeakAgain,:), 'ro')
end
subplot(1,2,1)
plot(decayTau, exp(-(decayTau)/lifetime1), 'b')
subplot(1,2,2)
plot(decayTau, exp(-(decayTau)/lifetime2), 'r')

stats(1,:) = mean(decayCurve_1000);
stats(3,:) = mean(decayCurve_870);
stats(2,:) = std(decayCurve_1000);
stats(4,:) = std(decayCurve_870);

figure(3)
hold on
errorbar(decayTau,stats(1,:),stats(2,:),'o', 'MarkerFaceColor', 'b')
plot(decayTau, exp(-(decayTau)/lifetime1), 'b')
errorbar(decayTau,stats(3,:),stats(4,:),'ro', 'MarkerFaceColor', 'r')
plot(decayTau, exp(-(decayTau)/lifetime2),'r')
xlim([0 2.5])
xlabel('Delay (ns)')
ylabel('Emission Rate (a.u.)')
set(gca, 'YScale', 'log')
% set(gca,'ytick',[0.5 0.75 1]);