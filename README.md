# Welcome to the ARC EEG resting-state wiki!

## What is this wiki for
This wiki is mainly intended to provide some minimal guidance on how to use the scripts provided in this section of my github. These scripts are to be used for analysis of resting state EEG data that was recorded on a 64-channel BioSemi ActiveTwo system with external electrode 6 (placed on the mastoid) as a reference electrode. It assumes trigger codes are used for eyes-closed and eyes-open segments and presently only uses eyes-closed segments. The currently assumed pre and post-processing steps are as follows:

1. Trials and triggers codes are read and only eyes-closed segments are selected
2. Very basic pre-processing includes: demeaning, detrending, low-pass filter below 60Hz, re-referencing to mastoid reference, bandpass filtering of possible 50Hz line-noise and resampling to 256Hz.
3. Optional visual inspection after basic pre-processing
4. Optional reconstruction of noisy channels (though only use this if a channel is absolutely rubbish!)
5. Removal of noise using ICA decomposition and visual inspection of resulting components
6. Segmenting continuous recording into 4-second segments to be used for WPLI analyses later on
7. Resetting the trial timestamp to allow fieldtrip to consider them separate 'trials'.
8. Calculate the weighted phase lag index using multi-taper fast fourier transform for each of the 5 frequency bands separately
9. Calculate various graph metrics from the WPLI adjacency matrices
10. Calculate frontal asymmetry and and intrahemispheric anterior-posterior balance

Steps 1-5 are useful and partly necessary to run manually (e.g. to check trial information and select ICA components mostly, but also to do a quick quality check of your data by visual inspection). Steps 5-9 can be (and are currently) automated and are best run at the end of your data collection phase when you are ready to start pre-processing as it concatenates all adjacency matrices in a single file.

## What assumptions are made
* You are using a BioSemi ActiveTwo 64 Channel recording system
* You are using the external channels on the BioSemi to get an additional reference
  * In our case (and hence in the current script) channel 6 is used to record a mastoid reference
* You have included trigger codes for the eyes-open and eyes-closed starting point
  * In our case we have 102 and 103 as codes for the eyes-closed triggers and 100 and 101 for eye-open
* We do not use the full minute but the middle 50s to avoid including the transition from eyes-open to eyes-closed
* Since we don't look at any frequencies above 60Hz we can downsample to 256Hz to speed up processing
* We resegement the recording into 4s epochs to somewhat articificially create trials that are need for WPLI analyses later on (i.e. we need to be able to average over multiple segments)
* Our pre-processing settings are fairly basic and easy to adjust in the script


## What scripts do what
There are 4 main scripts to get all of this done:

1. The pre-processing script found [here] (https://github.com/rb643/fieldtrip_restingState/blob/master/preprocessing.m) takes care of steps 1-5 This script is intended to be run manually for each individual subject. At the start it only requires the filename without an extension. Then each block of the script can be run manually. The reason for having it done manually are two-fold. First; it allows the users to inspect the data at at every step so that you can for example check if the triggers are read correctly, if there are specific channels that are noisy, if there are specific 'trials' that are noisy. Second; the ICA denoising steps currently relies on visual inspection of the components and thus has to be done manually (i.e. the users has to specific which components to remove in the script itself). Additionally, if the users decided to repair a specific channel the setting for the ICA have to be adjusted as every repaired channel removes a possible independent dimension from the ICA run. 
2. The WPLI script found [here] (https://github.com/rb643/fieldtrip_restingState/blob/master/rb_EEG_Conn) takes care of steps 6-8. It runs multi-taper fast fourier transform to split the data into the known frequency bands (theta, delta, alpha, beta, gamma) and runs the WPLI for every subjects. As an input it just takes in the directory that contains the individual .mat output files from the previous script and moves it to a subdirectory once it is done with it. It also changes the standard dimension of the ft_connectivityanalysis output to chan~chan~frequency so that you can obtain an adjacency matrix by averaging over frequency (within the overall frequency bands of cours). All output adjacency matrixes are stored as one combined mat file for each frequency band containing a subject~channel~channel matrix.
3. The Networks script found  [here] (https://github.com/rb643/fieldtrip_restingState/blob/master/wpli_networks.m) takes care of step 9. This currently computes some global and local graph metrics, but it can easily be extended. It takes the 3D matrix from the previous script as input as well as some basic settings for the graph analyses that are explained in more detail in the script.
4. The asymmetry script found [here] (https://github.com/rb643/fieldtrip_restingState/blob/master/rb_EEG_Assym.m) takes care of step 10. It currently computes 3 ratios (letf-right, left posterior-anterior, right posterior-anterior). As input it takes the folder with the frequency information files (pow*.*mat) that are generated during the MTFFT steps 6-8.

## Dependencies
There are a few external scripts/toolboxes that these wrapper scripts depend upon. Apart from the obvious need to have fieldtrip installed you will also need the following tools for the Networks script to work:
* A custom function to make your adjacency matrices symmetric that can be found [here] (https://github.com/rb643/fieldtrip_restingState/blob/master/rb_makeSymmetric.m). Annoyingly sometimes there are some very very small rounding errors in matlabs corrcoef or affiliated functions that make it look like the adjacency matrix is not symmetric. This will make all subsequent analysis fail so I've included a small script that ensures your input is symmetric
* The Brain Connectivity Toolbox (BCT) that you can find [here] (https://sites.google.com/site/bctnet/). This is the main toolbox used for computing any and all graph metrics. Fieldtrip does come with this toolbox included, but it might be worth to have the latest and most up to date version separate as well.

## Initial results
Some initial results are uploaded [here] (https://github.com/rb643/fieldtrip_restingState/blob/master/Output/README.md). 

### Notes:
* It is strongly recommended that after you've loaded your data with the first snippet of code in the preprocessing batch that you check whether your trial definitions are accurate by opening the cfg data structure and checking the trl timing field. If you've messed up the trigger codes somehow you will see straigh away that there are either to many trials or that trials are shorter than expected. Note also that this field just give you the number of datapoints not miliseconds, so if you have recorded at a sampling rate higher than 1024Hz you will likely see that the segment look 'longer'.
* Whatever you change in the settings: be consistent across your dataset!

### Platform note
Although this should be platform independent it has only been tested on a 64-bit Windows 8 Pro system and iOS 10.11.6 (El Capitan), with Matlab 2014B. If possible I have attempted to avoid using system specific file separators, but there is always a chance one has slipped through and makes the script throw errors.

### Still to do
* Create some statistical analysis scripts
* Upload scripts for visualizations
