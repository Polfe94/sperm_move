setwd('~/sperm_move/data')
source('../src/PLOT_FUNCTIONS.R')

BH <- read.csv('BHTSNE_Prediction.csv', check.names = F)
FIT <- read.csv('FITSNE_Prediction.csv', check.names = F)
UMAP <- read.csv('UMAP_Prediction.csv', check.names = F)

q1 <- read.csv('model_quantiles.csv')
q2 <- read.csv('FIT_quantiles.csv')
q3 <- read.csv('UMAP_quantiles.csv')

library(bayesplot)
library(ggplot2)
library(viridis)
library(gridExtra)
library(ggpubr)

ggplot2::theme_set(ggplot2::theme_classic() %+replace% ggplot2::theme(axis.ticks = element_line(color = 'black'),
                                                                      axis.title = element_text(color = 'black', size = 15),
                                                                      axis.text = element_text(color = 'black', size = 15),
                                                                      legend.text = element_text(color = 'black', size = 15),
                                                                      legend.title = element_text(color = 'black', size = 16),
                                                                      plot.title = element_text(color = 'black', size = 18, face = 'bold'),
                                                                      strip.text = element_text(color = 'black', size = 15)))

bayesplot::bayesplot_theme_set(ggplot2::theme_get())
bayesplot::color_scheme_set(as.character(c(color_scheme_get('brightblue')[1:4], 'black', 'black')))




#### +++ COEFFICIENTS +++ ####

a <- custom_intervals(q1[xor(grepl('Cluster', q1$parameter), q1$parameter == 'Sow parity'), ])+
        ggtitle('a')+ theme(plot.title = element_text(hjust = 0.05))+
        scale_x_continuous(breaks = c(-4e3, 0, 4e3))

c <- custom_intervals(q2[xor(grepl('Cluster', q2$parameter), q2$parameter == 'Sow parity'), ])+
        ggtitle('c')+ theme(plot.title = element_text(hjust = 0.05))+
        scale_x_continuous(breaks = c(-1e4, 0))

e <- custom_intervals(q3[xor(grepl('Cluster', q3$parameter), q3$parameter == 'Sow parity'), ])+
        ggtitle('e')+ theme(plot.title = element_text(hjust = 0.05)) +
        scale_x_continuous(breaks = c(-5e3, 0, 5e3, 1e4))

#### +++ PREDICTIONS +++ ####
pBH <- mcmc_intervals(BH, prob_outer = 0.95)$data

b <- custom_intervals(pBH, vlines = c(0.8, 0.9)) + 
     theme(text = element_text(family = ''))+
     scale_x_continuous('', breaks = seq(0, 1, 0.2), limits = c(0, 1))+
     ggtitle('b')+ theme(plot.title = element_text(hjust = 0.05))

pFIT <- mcmc_intervals(FIT, prob_outer = 0.95)$data

d <- custom_intervals(pFIT, vlines = c(0.8, 0.9)) + 
     theme(text = element_text(family = ''))+
     scale_x_continuous('', breaks = seq(0, 1, 0.2), limits = c(0, 1))+
     ggtitle('d')+ theme(plot.title = element_text(hjust = 0.05))


pUMAP <- mcmc_intervals(UMAP, prob_outer = 0.95)$data
f <- custom_intervals(pUMAP, vlines = c(0.8, 0.9)) + 
     theme(text = element_text(family = ''))+
     scale_x_continuous('', breaks = seq(0, 1, 0.2), limits = c(0, 1))+
     ggtitle('f')+ theme(plot.title = element_text(hjust = 0.05))


tiff(filename = '../plots/figS7.tiff', 4000, 6000, res  = 400)
grid.arrange(a,b,c,d,e,f, ncol = 2)
dev.off()

