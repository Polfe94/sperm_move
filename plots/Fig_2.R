setwd('~/sperm_move/data')
model <- read.csv('model_draws.csv')
model_quantiles <- read.csv('model_quantiles.csv')

# load libraries
library(ggplot2)
library(bayesplot)
library(viridis)
library(gridExtra)
library(ggpubr)

ggplot2::theme_set(ggplot2::theme_classic() %+replace% ggplot2::theme(axis.ticks = element_line(color = 'black'),
                                                                      axis.title = element_text(color = 'black', size = 15),
                                                                      axis.text = element_text(color = 'black', size = 15),
                                                                      legend.text = element_text(color = 'black', size = 15),
                                                                      legend.title = element_text(color = 'black', size = 16),
                                                                      plot.title = element_text(color = 'black', size = 18),
                                                                      strip.text = element_text(color = 'black', size = 15)))

bayesplot::bayesplot_theme_set(ggplot2::theme_get())
bayesplot::color_scheme_set(as.character(c(color_scheme_get('brightblue')[1:4], 'black', 'black')))

# plot layout
lay <- rbind(c(1,1,2,2,2))
a <- custom_intervals(model_quantiles[xor(grepl('Sow', model_quantiles$parameter), 
                                          grepl('Boar', model_quantiles$parameter)), ], point_size = 3) + 
     theme(plot.title = element_text(hjust = 0.1))+
     ggtitle('a')+
     theme(plot.margin = unit(c(0,0.1,0,0.1), 'cm'))
b <- custom_intervals(model_quantiles[xor(grepl('Non', model_quantiles$parameter), 
                                          grepl('Cluster', model_quantiles$parameter)), ], point_size = 3)+ 
     theme(plot.title = element_text(hjust = 0.1)) + scale_x_continuous(breaks = c(-4e3,0,4e3))+
     ggtitle('b')+
     theme(plot.margin = unit(c(0,0.1,0,0), 'cm'))

grid.arrange(a, b, layout_matrix = lay, bottom = text_grob('Coefficient magnitude', size = 17))

tiff('../plots/Fig_2.tiff', width = 18/2.54*600, height = 14/2.54*600,
     res = 600, units = 'px')
grid.arrange(a, b, layout_matrix = lay, bottom = text_grob('Coefficient magnitude', size = 17))
dev.off()
