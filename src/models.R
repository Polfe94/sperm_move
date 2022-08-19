setwd('~/sperm_move/')

## load functions and libraries
source('./src/FUNCTIONS.R')

## load sperm motility data
sperm <- read.csv('./data/sperm_data.csv')

## load fertility data
f <- read.csv('./data/fertility_data.csv')

## load previously computed tsne (check BHtSNE.R and FItSNE.R)
load('~/path/to/tsne.RData')
tsne <- BHtSNE # FItSNE 
## NOTE !! 
# If a list of tSNE with different perplexities was computed
# make sure that a single tSNE is analyzed in this script (at a time)

# number of merged clusters to scan
k <- 2:15

# compute models
models <- lapply(k, function(x){
     p <- cluster_proportions(tsne, sperm, f, do.merge = x)
     m <- model_fertility(p) # check defaults in FUNCTIONS.R
     # m <- model_fertility(p, chains = 4, iter = 4000, prior = normal(0, 5, autoscale = TRUE), adapt_delta = 0.99)
     m
})
names(models) <- paste('Number of clusters =', k)

# compute loo for model comparison
loos <- lapply(models, loo)
loo_compare(loos)

# take best model
model <- models[[10]]

# plot coefficients
bayesplot::mcmc_intervals(model)

# predictions
p <- get_predictions(model, cluster_proportions(tsne, sperm, f, do.merge = 11))
apply(p, 2, median) 
bayesplot::mcmc_intervals(p)
