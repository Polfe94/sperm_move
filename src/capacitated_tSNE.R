setwd('~/sperm_move/')

## load functions and libraries
source('./src/FUNCTIONS.R')

## load sperm motility data
cap_motdata <- read.csv('./data/cap_motdata.csv')

# apply whitening to data
Xw <- bdm.data(cap_motdata[, 1:4])[[1]][, ]

# initialize number of cores (threads) and perplexity (1%)
threads <- 20
ppx <- round(nrow(Xw)/100)

# compute 
combn_tsne <- bdm.bhtsne(Xw, 'Combined t-SNE',
                        ppx = ppx, threads = threads, dSet.labels = cap_motdata$Condition)
combn_tsne <- bdm.pakde(combn_tsne, ppx = ppx, threads = threads)
combn_tsne <- bdm.wtt(combn_tsne)
combn_tsne <- bdm.optk.s2nr(Xw, combn_tsne, info = FALSE, ret.optk = TRUE)

save(combn_tsne, file = '~/path/to/combn_tsne.RData')