### This folder contains some of the scripts that were used for visualization and statistics.

#### Script to visualize power spectral density
* [This] (https://github.com/rb643/fieldtrip_restingState/blob/master/Scripts/rb_plotPower.m) script can be used to visualize the output from the asymmetry analysis using the [fieldtrip topoplot] (http://www.fieldtriptoolbox.org/development/tutorial/plotting?s[]=ft&s[]=topoplot) function

#### Script to compare any set of matrices using permutation testing and FDR multiple comparison correction
* [This] (https://github.com/rb643/fieldtrip_restingState/blob/master/Scripts/rb_compareMatrices.m) script can be used to compare any set of two matrices. It runs pairwise comparisons using permutations for each cell and returns a matrix with all p-values, the threshold for FDR correction and a mask with all cells that pass that correction.

#### Set of R commands to visualize matrices
* [This] (https://github.com/rb643/fieldtrip_restingState/blob/master/Scripts/rb_plotting.R) script contains some R commands to visualize matrices as either heatmaps or chord diagrams. The latter uses the circlize package found [here] (https://cran.r-project.org/web/packages/circlize/index.html).
