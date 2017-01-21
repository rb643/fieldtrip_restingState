### This folder will contain some of the scripts that were used for visualization and statistics.

#### Script to visualize power spectral density
* [This] (https://github.com/rb643/fieldtrip_restingState/blob/master/Scripts/rb_plotPower.m) script can be used to visualize the output from the asymmetry analysis using the [fieldtrip topoplot] (http://www.fieldtriptoolbox.org/development/tutorial/plotting?s[]=ft&s[]=topoplot) function

#### Script to compare any set of matrices using permutation testing and FDR multiple comparison correction
* [This] (https://github.com/rb643/fieldtrip_restingState/blob/master/Scripts/rb_compareMatrices.m) script can be used to compare any set of two matrices. It run pairwise comparisons for each cell and return a matrix with all p-values, the threshold for FDR correction and a mask with all cells that pass that correction.

