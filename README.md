# README
## hBN paper figures repo
last edit 11/10/2018 - Robin

This repo contains the code/files to make the figures 2-4 for the NIR hBN paper. The figures are generated in the following scripts (details below):
 - hbnPaper_confocal_and_spectra.m
 - hbnPaper_g2_and_tau.m
 - plottingSherifsData.m

I use the export_fig package to export the figures in high quality so just make sure that the two folders are added to the path when you run the scripts.

Inkscape is then used to add the fig labels (a,b,...) and ensure the fig has the correct size (width should be 84mm). Inkscape files are included in subfolder, as of the commit from the 11th October 2018.

-------------------------------------------------------------
## details

### hbnPaper_confocal_and_spectra.m (fig2)
 - all the data is in the repo somewhere, just running the script should find it.
 - change file location on line 101 to save image where you want it.

TO DO:
 - make zoomed in insert showing the sub-poissonian emitter (or at least circle it or emphasize it), add scale bar (refer to image in hBN_NIRv2 ppt presentation for scalebar size).
 - remove 860nm spectrum as we don't have a theoretical explanation for it - just comment out line 40 and change xlim and XTick.
 - make smooth fit continuous line to the spectrum plot.


### hbnPaper_g2_and_tau.m (fig3)
 - (apologies for this one... it's so fucking stupid honestly)
 - lines 1-86 imports the experimental g2 data, normalises it, and plots it.
 - just ignore lines 87-144 - this is the Matlab implementation of my inverse exponentials g2 fit which you don't like.
 - **This exponentials fit is performed in the g2_by_autocorrelation.ipynb Jupyter notebook (in the g2modelling_qutip repo), where it is exported as a CSV - lines 146-154 import these CSVs and then plot them.**
 - lines 157-270 do the lifetime calculation and plotting (where again some of the calculation is done in that Jupyter notebook).
 - lines 277-297 is fig formatting.
 - line 299 exports fig (currently commented out).

TO DO:
 - Get rid of 860nm data - all the blue curves.
 - find better fit to the experimental g2 by using probabilistic model (in g2_by_autocorrelation-loris.ipynb), and plot this on top of experimental g2.
 - once better fit has been obtained replot emitter lifetime graph with new lifetime tau value.


### plottingSherifsData.m (fig4)
 - this pretty much just plots the data that Sherif sent me, and then using Inkscape everything is put together with the hexagonal lattice cartoon.
 
To DO
- fig 4a in red (to match experimental spectrum graph), get rid of fig 4b - explain that we will measure HR factor in future experiment;

---------------------------------------------------------------
## General to-do list re Writing

 - emphasise that only two emitters in NIR were sub-Poissonian;
 - remove reference to background emission as we didn't measure it - say instead that coinc counts are raw data (and re-check fitting);
 - remove 860nm PL emitter from paper (unless Sherif finds a theoretical explanation for it)
 - explain that we will measure HR factor in future experiment;
 - emphasise that the neutral N_B V_N defect emits in visible, but the negative emits in NIR - i.e. can electrically dope it to change emission.
