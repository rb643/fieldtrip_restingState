# Some R plotting scripts to visualize networks - mostly done by copy-pasting the matrices from Matlab

## plotting heatmaps with values 
## NOTE: only useful for smallish matrices and preferably trilled ones
# copy any matrix
x = read.delim(pipe("pbpaste"),header=FALSE)
# convert to a matrix
y = as.matrix(x)

library(gplots)
# round up the numbers
z = round(y,3)
# plot
heatmap.2(z,dendrogram = "none", Rowv = FALSE, Colv = FALSE, cellnote = z, notecol = "black", trace = 'none', density.info = 'none')

## plotting circular diagrams for EEG adjacency matrices
# EEG data
library(circlize)
# copy paste from matlab
cor_mat = read.delim(pipe("pbpaste"),header=FALSE)
cor_mat = as.matrix(cor_mat)
# set all the node/electrode names
EEGNames = c('Fp1','AF7','AF3','F1','F3','F5','F7','FT7','FC5','FC3','FC1','C1',
              'C3','C5','T7','TP7','CP5','CP3','CP1','P1','P3','P5','P7','P9','PO7',
              'PO3','O1','Lz','Oz','POz','Pz','CPz','Fpz','Fp2','AF8','AF4','AFz','Fz',
              'F2','F4','F6','F8','FT8','FC6','FC4','FC2','FCz','Cz','C2','C4','C6',
              'T8','TP8','CP6','CP4','CP2','P2','P4','P6','P8','P10','PO8','PO4','O2')
# colour in left and right electrodes in different colours (right = yellow, left = blue, central = grey)
grid.col = c(Fp1 = "blue",AF7 = "blue",AF3  = "blue", F1 = "blue", F3 = "blue", F5 = "blue",F7 = "blue",FT7 = "blue",FC5 = "blue",FC3 = "blue",FC1 = "blue",C1 = "blue",
             C3 = "blue",C5 = "blue",T7 = "blue",TP7 = "blue",CP5 = "blue",CP3 = "blue",CP1 = "blue",P1 = "blue",P3 = "blue",P5 = "blue",P7 = "blue",P9 = "blue",PO7 = "blue",
             PO3 = "blue",O1 = "blue",Lz = "grey",Oz = "grey",POz = "grey",Pz = "grey",CPz = "grey",Fpz = "grey",Fp2 = "yellow",AF8 = "yellow",AF4 = "yellow",AFz = "grey",Fz = "grey",
             F2 = "yellow",F4 = "yellow",F6 = "yellow",F8 = "yellow",FT8 = "yellow",FC6 = "yellow",FC4 = "yellow",FC2 = "yellow",FCz = "grey",Cz = "grey",C2 = "yellow",C4 = "yellow",C6 = "yellow",
             T8 = "yellow",TP8 = "yellow",CP6 = "yellow",CP4 = "yellow",CP2 = "yellow",P2 = "yellow",P4 = "yellow",P6 = "yellow",P8 = "yellow",P10 = "yellow",PO8 = "yellow",PO4 = "yellow",O2 = "yellow")

# change column names
rownames(cor_mat) = EEGNames
colnames(cor_mat) = EEGNames

# convert correlations to colours
col_fun = colorRamp2(c(-1, 0, 1), c("darkblue", "white", "darkred"))

# plot and save to pdf
pdf("figure.pdf",width=12,height=12,paper='special') 
col_mat = col_fun(cor_mat)
col_mat[abs(cor_mat) < 0.2394] = "#00000000" # set threshold below 10% to transparent, this is also defined in Matlab
chordDiagram(cor_mat, grid.col = grid.col, col = col_mat, symmetric = TRUE)
dev.off()
