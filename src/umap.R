## load functions and libraries
source('path/to/FUNCTIONS.R')

## load sperm motility data
load('~/path/to/sperm.RData')

# variables to compute t-SNE with
vars <- c('VCL','VSL','ALH','BCF')

# data without duplicates
df <- na.omit(sperm[!duplicated(sperm[, vars]), vars])
Xw <- bdm.data(df)[[1]][,]
colnames(Xw) <- vars

# +++ load UMAP output
umap <- rjson::fromJSON(file = '~/path/to/umap.json')

ppx <- c(64, 320, 639, 3197, 6393)
percent <- (0.1, 0.5, 1, 5, 10)

umap.list <- lapply(seq_along(umap), function(u)
{
        m <- init_tsne(umap[[u]], ppx = ppx[u], data = df, dSet = paste0('UMAP_', percent[u], '%'))

        # +++ pakde
        m <- bdm.pakde(m, ppx = ppx[u], threads = 4)
        # +++ wtt
        m <- bdm.wtt(m)
        # +++ kNP
        m <- bdm.knp(Xw, m, threads = 4)
        # +++ hlC
        m <- bdm.hlCorr(Xw, m, threads = 4)
        m
})

# +++ save
save(umap.list, file = '/path/to/results/umap.RData')


