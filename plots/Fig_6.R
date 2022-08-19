setwd('~/sperm_move/data')

xyz <- read.csv('pakde_merged.csv')
lns <- read.csv('cluster_merged_borders.csv')
pks <- read.csv('cluster_merged_peaks.csv')
loo <- read.csv('BHtsne_loo.csv')
s2nr <- read.csv('BHtsne_s2nr.csv')

library(ggplot2)
library(shadowtext)
library(viridis)
library(gridExtra)

# theme customization
ggplot2::theme_set(ggplot2::theme_classic() %+replace% ggplot2::theme(axis.ticks = element_line(color = 'black'),
                                                                      axis.title = element_text(color = 'black', size = 15),
                                                                      axis.text = element_text(color = 'black', size = 15),
                                                                      legend.text = element_text(color = 'black', size = 15),
                                                                      legend.title = element_text(color = 'black', size = 16),
                                                                      plot.title = element_text(color = 'black', size = 18),
                                                                      strip.text = element_text(color = 'black', size = 15)))

A <- ggplot(data = s2nr, aes(K,H)) + ggtitle('a') + 
     scale_x_reverse('Number of clusters', 
                     breaks = c(2, seq(max(s2nr$K), 13, -5), 8, c(11, 5)))+
     scale_y_continuous('Information gain (S2NR)', breaks = seq(0, 1, 0.05))+
     geom_vline(xintercept = c(11, 5), # loss in information
                linetype = 2, color = 'grey80', size = 1.25)+
     geom_line(size = 1.2, color = viridis(1, end= 0.8))+
     theme(plot.title= element_text(hjust = 0.12, face = 'bold'))

B <- ggplot(data = loo, aes(n_clusters, elpd_diff))+
        geom_segment(data = loo[loo$n_clusters == 11, ], aes(x = n_clusters, xend = n_clusters,
                                                      y = -Inf, yend = elpd_diff),
                     color = 'grey70', linetype = 2, size = 1.2)+
        geom_smooth(alpha = 0.2, formula = y ~ splines::bs(x, 3), method = 'lm',
                    se = FALSE, color = viridis(1, end = 0.8))+
        geom_point(color = viridis(1, end = 0.8)) +
        theme(plot.title= element_text(hjust = 0.15, face = 'bold')) + 
        ggtitle('b') + scale_x_continuous('Number of Clusters', breaks = seq(2, 15, 2))+
        ylab('ELPD')

     
# landscape
options(scipen = -1)
xyz$z[xyz$z < quantile(xyz$z, probs = 0.5)] <- NA

C <- ggplot(data = xyz, aes(x = x, y = y)) + 
     geom_raster(aes(fill = z))+
     geom_contour(aes( z = z), bins = 10, color = 'grey99')+
     scale_fill_gradientn('Density', colours = mixOmics::color.jet(200), na.value = 'white') +theme_void() +xlab('') + ylab('')+
     geom_point(data = lns, aes(x, y), color = 'white', size = 0.9)+
     ggtitle('c')+
     geom_shadowtext(data = pks, aes(x, y, label = C), fontface = 'bold', size = 6.5)+
     theme(plot.title = element_text(hjust = 0.15, face = 'bold',vjust = 8.5, size = 18),
           aspect.ratio = 1, legend.title = element_text(size = 16), legend.text = element_text(size = 15))

tiff('../plots/fig6.tiff', 4800, 2400, res = 400)
grid.arrange(A, B, C, layout_matrix = matrix(c(1,2,3,3), ncol = 2))
dev.off()
