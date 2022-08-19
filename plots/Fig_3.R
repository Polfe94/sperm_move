options(scipen = -1)
setwd('~/sperm_move/data')

model <- read.csv('model_draws.csv')
xyz <- read.csv('pakde_merged.csv')
lns <- read.csv('cluster_merged_borders.csv')
pks <- read.csv('cluster_merged_peaks.csv')
sperm <- read.csv('sperm.csv')


library(ggplot2)
library(viridis)
library(shadowtext)
library(reshape2)
library(ggpubr)


# theme customization
ggplot2::theme_set(ggplot2::theme_classic() %+replace% ggplot2::theme(axis.ticks = element_line(color = 'black'),
                                                                      axis.title = element_text(color = 'black', size = 15),
                                                                      axis.text = element_text(color = 'black', size = 15),
                                                                      legend.text = element_text(color = 'black', size = 15),
                                                                      legend.title = element_text(color = 'black', size = 16),
                                                                      plot.title = element_text(color = 'black', size = 18),
                                                                      strip.text = element_text(color = 'black', size = 15)))



# retrieve coefficients from the model (i.e. median of the drawn samples)
coeffs <- apply(model,2, median)
k_coeffs <- sort(coeffs[grepl('Cluster', names(coeffs))])
k <- as.numeric(gsub('Cluster.', '', names(k_coeffs)))

# color palette for the different groups (i.e. positive / negative effect on fertility)
pltt <- c(rep(viridis(1, end = 0.5, begin = 0.5), sum(k_coeffs < 0)),
          rep(viridis(1, begin = 0.7, end = 0.8), sum(k_coeffs > 0)))
names(pltt) <- k[order(k_coeffs)]

# replace clusters with a binary classification (equal to color palette)
colr <- as.character(xyz$c)
for(i in 1:length(pltt)){
     colr[colr == names(pltt)[i]] <- pltt[i]
}

# filter low density in the landscape
xyz$c[xyz$z < quantile(xyz$z, probs = 0.5)] <- NA

B <- ggplot(data = xyz, aes(x = x, y = y)) + 
     geom_raster(aes(fill = factor(c)), show.legend = F) + 
     scale_fill_manual(values = pltt, na.value = 'white')+
     geom_contour(aes( z = z), bins = 10, color = 'grey99') + theme_void() +xlab('') + ylab('')+
     geom_point(data = lns, aes(x, y), color = 'white', size = 0.9)+
     geom_shadowtext(data = pks, aes(x, y, label = C), color = 'white', fontface = 'bold', size = 8)+
     theme(plot.title = element_text(hjust = 0.1, face = 'bold', size = 20), aspect.ratio = 1,
           plot.margin = unit(c(0, -1.75, 0, 0), 'cm'))



ord_idx <- sapply(c('VCL', 'VSL', 'ALH', 'BCF', 'VAP', 'LIN', 'STR', 'WOB'), function(i) which(colnames(sperm) == i))
colnames(sperm)[ord_idx] <- c(expression(paste('VCL (',mu,'m/s)', sep='')),
                             expression(paste('VSL (',mu,'m/s)', sep='')),
                             expression(paste('ALH (',mu,'m)', sep='')),
                             expression(paste('BCF (Hz)', sep='')),
                             expression(paste('VAP (',mu,'m/s)', sep='')),
                             expression(paste('LIN (%)', sep = '')),
                             expression(paste('STR (%)', sep = '')),
                             expression(paste('WOB (%)', sep = '')))

mlt_data <- melt(sperm[sperm$mK != 0, c(ord_idx, which(colnames(sperm) == 'mK'), ncol(sperm))],
                 id.vars = c('effect', 'mK'))


A <- ggplot(data = mlt_data, aes(factor(effect), value, fill = factor(effect))) +
     geom_boxplot(outlier.shape = 1) + facet_wrap(~ variable, scales = 'free_y', labeller = label_parsed,
                                                  nrow = 4, ncol = 2)+ # ALL T test are significant
     scale_fill_manual('Effect on fertility', values = c(viridis(1, begin = 0.5, end = 0.5),
                                                         viridis(1, begin = 0.7, end = 0.8)))+ 
     scale_color_manual('', values = c('white', 'black'))+
     xlab('') + ylab('') + theme(axis.text.x = element_blank(), axis.ticks.x = element_blank(),
                                 strip.text = element_text(size = 17, margin = margin(0.21,0,0.21,0,'cm')),
                                 plot.margin = unit(c(2, -0.8, 0, 0), 'cm'),
                                 plot.title = element_text(vjust = 2.5, hjust = 0.1))


tiff('../plots/fig3.tiff', 4000, 2000, res = 300)
ggarrange(A,B, labels = c('a', 'b'), font.label = list(size = 20), hjust = c(-.5, -5))
dev.off()


### MEASURES ###

for(i in c('VCL', 'VSL', 'ALH', 'BCF', 'VAP', 'LIN', 'STR', 'WOB')){
        idx <- colnames(sperm) == 'effect' | grepl(i, colnames(sperm))
        n <- sperm[, idx]
        colnames(n)[1] <- i
        test <- t.test(formula = formula(paste(i, '~ effect')), data = n, conf.level = 0.95)
        a <- aggregate(formula = formula(paste(i, '~ effect')), data = n, FUN = mean)
        print(test)
        print(paste('Fold change of', max(a[, 2])/min(a[, 2])))
}
