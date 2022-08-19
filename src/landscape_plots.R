setwd('~/sperm_move/')

## load sperm motility data
sperm <- read.csv('./data/sperm_data.csv')

# variables to compute t-SNE with
vars <- c('VCL','VSL','ALH','BCF')

# data without duplicates
df <- na.omit(sperm[!duplicated(sperm[, vars]), vars])
Xw <- bdm.data(df)[[1]][,]
colnames(Xw) <- vars

## Load an embedding (bigMap) object (i.e. as obtained by running BHtSNE.R)
load('/path/to/BHtSNE.RData')


bdm.ptsne.plot(BHtSNE)

# requires to compute pakde first (bdm.pakde(BHtSNE), ppx = 639)
bdm.pakde.plot(BHtSNE)

# requires pakde and wtt (bdm.wtt(BHtSNE))
bdm.wtt.plot(BHtSNE)

# try merging the landscape, and see how the clusters rearrange
BHtSNE <- bdm.merge.s2nr(Xw, BHtSNE, k = 10, plot.merge = T, ret.merge = T, info = F)

# plot merging
# bdm.wtt.plot(BHtSNE)

# explore how variables are distributed along the landscape
bdm.qMap(BHtSNE, data = df)

# explore the signal to noise ratio (information gain along the merging process)
bdm.optk.plot(BHtSNE)