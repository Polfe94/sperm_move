setwd('~/sperm_move/')

## load functions and libraries
source('./src/FUNCTIONS.R')

## load sperm motility data
sperm <- read.csv('./data/sperm_data.csv')

# variables to compute t-SNE with
vars <- c('VCL','VSL','ALH','BCF')

# data without duplicates
df <- na.omit(sperm[!duplicated(sperm[, vars]), vars])
Xw <- bdm.data(df)[[1]][,]
colnames(Xw) <- vars

# init number of cores (threads) and perplexity
threads <- 20
ppx_list <- c(0.1, 0.5, 1, 5, 10)

BHtsne <- lapply(ppx_list, function(x){
     ppx <- round(nrow(Xw)*x*0.01)
     
     # compute Barnes Hut t-SNE
     X <- bdm.bhtsne(Xw, paste('Perplexity ', x, '%', sep = ''),
                     ppx = ppx, threads = threads)
     
     # kernel density, cluster assignation, signal to noise ratio and K-ary neighbour preservation
     X <- bdm.pakde(X, ppx = ppx, threads = threads)
     X <- bdm.wtt(X)
     X <- bdm.optk.s2nr(Xw, X, info = FALSE, ret.optk = TRUE, plot.optk = FALSE)
     X <- bdm.knp(Xw, X, threads = threads)
})

# comparison of quality based on the K-ary neighbour preservation criteria
bdm.knp.plot(BHtsne)

# save results
# BHtsne <- BHtsne[[3]] # keep only the best quality embedding
save(BHtsne, file = '~/path/to/BHtsne.RData')

