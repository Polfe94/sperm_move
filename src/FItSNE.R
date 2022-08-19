## load functions and libraries
source('~/sperm_move/src/FUNCTIONS.R')

## load FIt-SNE
source('~/FitSNE/fast_tsne.R')
# make sure to point to the proper folder
FAST_TSNE_SCRIPT_DIR <- '~/path/to/FitSNE/'

## load sperm motility data
sperm <- read.csv('~/sperm_move/data/sperm_data.csv')

# variables to compute t-SNE with
vars <- c('VCL','VSL','ALH','BCF')

# data without duplicates
df <- na.omit(sperm[!duplicated(sperm[, vars]), vars])
Xw <- bdm.data(df)[[1]][,]
colnames(Xw) <- vars

# init number of cores (threads) and perplexity
threads <- 20
ppx_list <- c(0.1, 0.5, 1, 5, 10)

FItsne <- lapply(ppx_list, function(x){
     ppx <- round(nrow(Xw)*x*0.01)
     
     # compute Fast Fourier interpolation t-SNE
     X <- fftRtsne(Xw, perplexity = ppx)
     
     # create bigMap-like tsne object
     X <- init_tsne(X, ppx = ppx, data = df, dSet = paste('Perplexity ', x, '%', sep = ''))
     
     # kernel density, cluster assignation, signal to noise ratio and K-ary neighbour preservation
     X <- bdm.pakde(X, ppx = ppx, threads = threads)
     X <- bdm.wtt(X)
     X <- bdm.optk.s2nr(Xw, X, info = FALSE, ret.optk = TRUE, plot.optk = FALSE)
     X <- bdm.knp(Xw, X, threads = threads)
})

# comparison of quality based on the K-ary neighbour preservation criteria
bdm.knp.plot(FItsne)

# save results
# FItsne <- FItsne[[3]] # keep only the best quality embedding
save(FItsne, file = '~/path/to/FItsne.RData')
