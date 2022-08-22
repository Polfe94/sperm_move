setwd('~/sperm_move/data')

sperm <- read.csv('sperm.csv')
model <- read.csv('model_draws.csv')

library(reshape2)
library(ggplot2)
library(viridis)


ord_idx <- sapply(c('VCL', 'VSL', 'ALH', 'BCF', 'VAP', 'LIN', 'STR', 'WOB'), function(i) which(colnames(sperm) == i))
colnames(sperm)[ord_idx] <- c(expression(paste('VCL (',mu,'m/s)', sep='')),
                             expression(paste('VSL (',mu,'m/s)', sep='')),
                             expression(paste('ALH (',mu,'m)', sep='')),
                             expression(paste('BCF (Hz)', sep='')),
                             expression(paste('VAP (',mu,'m/s)', sep='')),
                             expression(paste('LIN (%)', sep = '')),
                             expression(paste('STR (%)', sep = '')),
                             expression(paste('WOB (%)', sep = '')))

sperm <- sperm[!is.na(sperm$effect), ]

pltt <- c(viridis(length(unique(sperm$mK[sperm$effect == 'Negative'])), end = 0.36),
          viridis(length(unique(sperm$mK[sperm$effect == 'Positive'])), begin = 0.54, end = 0.95))

# retrieve coefficients from the model (i.e. median of the drawn samples)
coeffs <- apply(model,2, median)
k_coeffs <- sort(coeffs[grepl('Cluster', names(coeffs))])
k <- as.numeric(gsub('Cluster.', '', names(k_coeffs)))

mlt_data <- melt(sperm[, c(ord_idx, ncol(sperm)-1, ncol(sperm))], id.vars = c('effect', 'mK'))

A <- ggplot(data = mlt_data)+
        geom_boxplot(aes(factor(effect), value,
                         fill = factor(mK, levels = k)), outlier.shape = 1) +
        facet_wrap(~ variable, nrow = 2, ncol = 4, scales = 'free_y', labeller = label_parsed) +
        scale_fill_manual('Cluster', values = pltt) + 
        theme_classic()+ geom_vline(xintercept = 1.5, linetype = 2, size = 1.2, color = 'grey70')+
        scale_x_discrete('Effect on fertility', labels = c('-', '+')) + ylab('')+
        theme(plot.title = element_text(face = 'bold', size = 20, vjust = 3, hjust = 0.04),
              axis.text = element_text(size = 18, color = 'black'),
              axis.title = element_text(size = 18, color = 'black'),
              legend.title = element_text(size = 18, color = 'black'),
              legend.text = element_text(size = 17.5, color = 'black'),
              strip.text = element_text(size = 17, margin = margin(0.21,0,0.21,0,'cm')),
              axis.ticks.x = element_blank(),
              plot.margin = unit(c(1, 0, 0.5, 0.5), 'cm'))


tiff('../plots/figS4.tiff', 3200, 2000, res = 400)
A
dev.off()
