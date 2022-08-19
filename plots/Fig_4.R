setwd('~/sperm_move/data')

pred <- read.csv('BH_quantiles.csv')
m <- read.csv('counts_matrix.csv')
tbl <- read.csv('boar_ranking.csv')

library(ggplot2)
library(gridExtra)
library(ggpubr)
library(bayesplot)
library(viridis)

ggplot2::theme_set(ggplot2::theme_classic() %+replace% ggplot2::theme(axis.ticks = element_line(color = 'black'),
                                                                      axis.title = element_text(color = 'black', size = 15),
                                                                      axis.text = element_text(color = 'black', size = 15),
                                                                      legend.text = element_text(color = 'black', size = 15),
                                                                      legend.title = element_text(color = 'black', size = 16),
                                                                      plot.title = element_text(color = 'black', size = 18),
                                                                      strip.text = element_text(color = 'black', size = 15)))

bayesplot::bayesplot_theme_set(ggplot2::theme_get())
bayesplot::color_scheme_set(as.character(c(color_scheme_get('brightblue')[1:4], 'black', 'black')))

b <- custom_intervals(pred, prob = 0.5, prob_outer = 0.95, vlines = c(0.8, 0.9)) + 
     theme(plot.title = element_text(hjust = 0.1), text = element_text(family = ''),
           plot.margin = unit(c(2.5,0.5,2.5,0), 'cm'))+
     scale_x_continuous('Predicted fertility probability', breaks = seq(0, 1, 0.2), limits = c(0, 1))



# values to probabilities
colnames(m) <- gsub('Boar.', 'Boar ', colnames(m))
m <- m / 1000 # counts divided by the number of iterations in the bootstrap

# add columns to the ranking table
rownames(tbl) <- pred$parameter
tbl = cbind(tbl, Probability = round(sapply(1:nrow(m), function(i) m[i, rownames(tbl)[i]]), 3),
            # compute entropy
            Entropy = sapply(1:nrow(m), function(i){
                 x <- m[,rownames(tbl)[i]] * log(m[, rownames(tbl)[i]])
                 round(abs(sum(x[is.finite(x)])), 3)
            }))


# table formatting ...
tbl <- apply(tbl, 2, as.character)
tbl <- apply(tbl, 2, function(i){
     sapply(i, function(x){
          if(nchar(x) == 1){
               x <- paste(x, '.000', sep = '')
          } else {
               x <- paste(x, paste(rep('0', (5 - nchar(x))), collapse = '', sep = ''), sep = '')
          } 
          x
     })
})
rownames(tbl) <- pred$parameter

ggarrange(tableGrob(tbl), b, nrow = 1, labels = c('a', 'b'), font.label = list(size = 20))


tiff('../plots/fig4.tiff', 8000, 4300, res = 600)
ggarrange(tableGrob(tbl), b, nrow = 1, labels = c('a', 'b'), font.label = list(size = 20),
          vjust = 3, hjust = c(-8.3, 0))
dev.off()


