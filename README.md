# Welcome to the ARC EEG resting-state wiki!

## What is this wiki for
This wiki is mainly intended to provide some minimal guidance on how to use the scripts provided in this section of my github. These scripts are to be used for analysis of resting state EEG data that was recorded on a 64-channel BioSemi ActiveTwo system with external electrode 6 (placed on the mastoid) as a reference electrode. It assumes trigger codes are used for eyes-closed and eyes-open segments and presently only uses eyes-closed segments. The currently assumed pre and post-processing steps are as follows:

1. Trials and triggers codes are read and only eyes-closed segments are selected
2. Very basic pre-processing includes: demeaning, detrending, low-pass filter below 60Hz, re-referencing to mastoid reference, bandstop filtering of possible 50Hz line-noise and resampling to 1024Hz.
3. Optional visual inspection after basic pre-processing
4. Optional reconstruction of noisy channels (thought only use this if a channel is absolutely rubbish!)
5. Segmenting continuous recording into 4-second segments to be used for WPLI analyses later on
6. Removal of noise using ICA decomposition and visual inspection of resulting components
7. Resetting the trial timestamp to allow fieldtrip to consider them separate 'trials'.
8. Calculate the weighted phase lag index using wavelet decomposition for each of the 5 frequency bands separately
9. Calculate various graph metrics from the WPLI adjacency matrices

## What scripts do what
There are 3 main scripts to get all of this done:

1. The pre-processing script found [here] (https://github.com/rb643/fieldtrip_restingState/blob/master/preprocessing.m) takes care of steps 1-7 This script is intended to be run manually for each individual subject. At the start it only requires the filename without an extension. Then each block of the script can be run manually. The reason for having it done manually are two-fold. First; it allows the users to inspect the data at at every step so that you can for example check if the triggers are read correctly, if there are specific channels that are noisy, if there are specific 'trials' that are noisy. Second; the ICA denoising steps currently relies on visual inspection of the components and thus has to be done manually (i.e. the users has to specific which components to remove in the script itself). Additionally, if the users decided to repair a specific channel the setting for the ICA have to be adjusted as every repaired channel removes a possible independent dimension from the ICA run. 
2. The WPLI script found [here] (https://github.com/rb643/fieldtrip_restingState/blob/master/wpli_connectivity.m) takes care of step 8. It runs wavelet decomposition to split the data into the known frequency bands (theta, delta, alpha, beta, gamma) and runs the WPLI for every subjects. As an input it just takes in the directory that contains the individual *.mat output files from the previous script and moves it to a subdirectory once it is done with it. It also changes the standard dimension of the ft_connectivityanalysis output to chan*chan*frequency so that you can obtain an adjacency matrix by averaging over frequency (within the overall frequency bands of cours). All output adjacency matrixes are stored as one combined mat file for each frequency band containing a subject*channel*channel matrix.
3. The Networks script found  [here] (https://github.com/rb643/fieldtrip_restingState/blob/master/wpli_networks.m) takes care of step 9. This currently computes some global and local graph metrics, but it can easily be extended. It takes the 3D matrix from the previous script as input as well as some basic settings for the graph analyses that are explained in more detail in the script.

## Dependencies
There are a few external scripts/toolboxes that these three wrapper scripts depend upon. Apart from the obvious need to have fieldtrip installed you will also need the following tools for the Networks script to work:
* A custom function to make your adjacency matrices symmetric that can be found [here] (https://github.com/rb643/fieldtrip_restingState/blob/master/rb_makeSymmetric.m). Annoyingly sometimes there are some very very small rounding errors in matlabs corrcoef or affiliated functions that make it look like the adjacency matrix is not symmetric. This will make all subsequent analysis fail so I've included a small script that ensures your input is symmetric
* The Brain Connectivity Toolbox (BCT) that you can find [here] (https://sites.google.com/site/bctnet/). This is the main toolbox used for computing any and all graph metrics. Fieldtrip does come with this toolbox included, but it might be worth to have the latest and most up to date version separate as well.

### Platform note
Although this should be platform independent it has only been tested on a 64-bit Windows 8 Pro systems, with Matlab 2014B. If possible I have attempted to avoid using system specific file separators, but there is always a chance one has slipped through and makes the script throw errors.
