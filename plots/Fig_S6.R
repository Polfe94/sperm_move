setwd('~/sperm_move/data')

loo <- read.csv('comparison_loo.csv')
s2nr <- read.csv('comparison_s2nr.csv')

library(ggplot2)
library(gridExtra)


# theme customization
ggplot2::theme_set(ggplot2::theme_classic() %+replace% ggplot2::theme(axis.ticks = element_line(color = 'black'),
                                                                      axis.title = element_text(color = 'black', size = 15),
                                                                      axis.text = element_text(color = 'black', size = 15),
                                                                      legend.text = element_text(color = 'black', size = 15),
                                                                      legend.title = element_text(color = 'black', size = 16),
                                                                      plot.title = element_text(color = 'black', size = 18),
                                                                      strip.text = element_text(color = 'black', size = 15)))


B <- ggplot(data = loo, aes(n_clusters, elpd_diff, color = factor(model)))+
        geom_segment(data = data.frame(x = c(11, 13, 14),
                                       xend = c(11, 13, 14),
                                       y = -Inf, 
                                       yend = c(loo$elpd_diff[loo$model == 'Barnes-Hut' & loo$n_clusters == 11],
                                                loo$elpd_diff[loo$model == 'FIt-SNE' & loo$n_clusters == 13],
                                                loo$elpd_diff[loo$model == 'UMAP' & loo$n_clusters == 14])),
                     aes(x = x, xend = xend, y = y, yend= yend),
                     color = 'grey70', linetype = 2, size = 1.2)+

        geom_smooth(alpha = 0.2, formula = y ~ splines::bs(x, 3), method = 'lm',
                    se = FALSE, show.legend = F)+ geom_point() + scale_color_viridis_d('Embedding', end = 0.8)+
        theme(plot.title= element_text(face = 'bold', hjust = -0.05)) + 
        ggtitle('b') + scale_x_continuous('Number of Clusters', breaks = seq(2, 15, 2))+
        ylab('ELPD')



selected_models <- data.frame(x = c(11, 13, 14),
                              xend = c(11, 13, 14),
                              y = -Inf, 
                              yend = c(s2nr$S2NR[s2nr$Embedding == 'Barnes-Hut' & s2nr$Clusters == 11],
                                       s2nr$S2NR[s2nr$Embedding == 'FIt-SNE' & s2nr$Clusters == 13],
                                       s2nr$S2NR[s2nr$Embedding == 'UMAP' & s2nr$Clusters == 14]))
A <- ggplot(data = s2nr, aes(Clusters, S2NR, color = factor(Embedding))) + 
        geom_segment(data = selected_models,
                     aes(x = x, xend = xend, y = y, yend= yend),
                     color = 'grey70', linetype = 2, size = 1.2)+
        geom_line(size = 1.25, show.legend = F)+ 
        ylab('S2NR')+
        scale_x_reverse(breaks = seq(2, max(s2nr$Clusters), 5)) + 
        scale_color_viridis_d('Embedding', labels = c('Barnes-Hut', 'FIt-SNE', 'UMAP'), end = 0.75)+
        geom_point(data = selected_models, aes(x, yend), color = 'black', size = 2)+
        ggtitle('a') + theme(plot.title = element_text(face = 'bold', hjust = -0.03))


tiff('../plots/figS6.tiff', 16*400, 6.5*400, res = 400)
grid.arrange(A, B, layout_matrix = rbind(c(1, 1, 1, 1, 2, 2, 2)))
dev.off()
