setwd('~/sperm_move/data')

source('../src/PLOT_FUNCTIONS.R')
sperm <- read.csv('fig_s2.csv')

library(ggplot2)
library(gridExtra)

ggplot2::theme_set(ggplot2::theme_classic() %+replace% ggplot2::theme(axis.ticks = element_line(color = 'black'),
                                                                      axis.title = element_text(color = 'black', size = 15),
                                                                      axis.text = element_text(color = 'black', size = 15),
                                                                      legend.text = element_text(color = 'black', size = 15),
                                                                      legend.title = element_text(color = 'black', size = 16),
                                                                      plot.title = element_text(color = 'black', size = 18, face = 'bold'),
                                                                      strip.text = element_text(color = 'black', size = 15)))

casa <- qMap(sperm[, c('x','y')], sperm[, c('VCL', 'VSL', 'ALH', 'BCF', 'Type', 'VAP', 'LIN', 'STR', 'WOB')],
             factor.pltt = mixOmics::color.jet, which.factor = 5,
             labels = c(expression(paste('VCL (',mu,'m/s)', sep='')),
                        expression(paste('VSL (',mu,'m/s)', sep='')),
                        expression(paste('ALH (',mu,'m)', sep='')),
                        paste('BCF (Hz)', sep=''),
                        'CASA class',
                        expression(paste('VAP (',mu,'m/s)', sep='')),
                        'LIN (%)', 'STR (%)', 'WOB (%)'))
# guides(color = guide_legend(override.aes = list(alpha = 1)))
casa[[1]] <- casa[[1]] + ggtitle('a') +
     theme(plot.title = element_text(hjust = 0.1, vjust = 5.8))
casa[[2]] <- casa[[2]] + ggtitle('')
casa[[3]] <- casa[[3]] + ggtitle('')
casa[[4]] <- casa[[4]] + ggtitle('')
casa[[5]] <- casa[[5]] +ggtitle('b') +
     theme(plot.title = element_text(hjust = 0.1, vjust = 16.7))
casa[[6]] <- casa[[6]] + ggtitle('c')+
     theme(plot.title = element_text(hjust = -0.41, vjust = 1),
           plot.margin = unit(c(5.5, 5.5, 5.5, 50), 'points'))
casa[[7]] <- casa[[7]] + ggtitle('')
casa[[8]] <- casa[[8]] + ggtitle('')+
     theme(plot.margin = unit(c(5.5, 5.5, 5.5, 50), 'points'))
casa[[9]] <- casa[[9]] + ggtitle('')
lay <- rbind(c(1,1,1,2,2,2,5,5,5,5),
             c(3,3,3,4,4,4,5,5,5,5),
             c(6,6,6,6,6,7,7,7,7,7),
             c(8,8,8,8,8,9,9,9,9,9))


tiff('../plots/figS2.tiff', 5000, 5000, res = 400)
grid.arrange(casa[[1]], casa[[2]], casa[[3]], casa[[4]], casa[[5]],
             casa[[6]], casa[[7]], casa[[8]], casa[[9]],
             layout_matrix = lay)
dev.off()
