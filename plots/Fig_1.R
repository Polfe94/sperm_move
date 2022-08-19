setwd('~/sperm_move/data/') # set working directory to data folder

# load data
xyz <- read.csv('pakde.csv')
lns <- read.csv('cluster_borders.csv')
pks <- read.csv('cluster_peaks.csv')

# load libraries 
library(bigMap)
library(ggpubr)
library(ggplot2)
library(gridExtra)

# filter the low density in the landscape, to turn the background to white
xyz$z[xyz$z < quantile(xyz$z, probs = 0.5)] <- NA

# install mixOmics, or change color palette (e.g. colours = rainbow(200, rev = TRUE))
a <- ggplot(data = xyz, aes(x = x, y = y, fill = z)) + geom_raster() + 
     scale_fill_gradientn('', colours = mixOmics::color.jet(200), na.value = 'white',
                          limits = c(min(xyz$z, na.rm = TRUE), max(xyz$z, na.rm = TRUE)),
                          breaks = c(min(xyz$z, na.rm = TRUE), max(xyz$z, na.rm = TRUE)),
                          labels = c('Low', 'High')) + theme_void() +
     geom_contour(aes( z = z), bins = 15, color = 'grey99', alpha = 0.4) +
     theme(legend.position = 'bottom',
           legend.key.width = unit(c(20),'mm'), legend.text = element_text(size = 10), aspect.ratio = 1,
           plot.title = element_text(vjust = -3, hjust = 0.2, face = 'bold'))+
     ggtitle('a')

# wtt
b <- ggplot() + geom_raster(data = xyz, aes(x = x, y = y, fill = z),show.legend = F) + 
     geom_contour(data = xyz, aes(x = x, y = y, z=z), bins = 15, color = 'grey99', alpha = 0.4)+
     scale_fill_gradientn('',colours = mixOmics::color.jet(200), na.value = 'white')+ theme_void() +
     geom_point(data = lns, aes(x,y), color = 'white', size = 0.01, alpha = 0.6) + 
     theme(aspect.ratio = 1, plot.title = element_text(vjust = -3, hjust = 0.2, face = 'bold'))+
     geom_point(data = pks, aes(x,y), shape = 17, size = 1.7)+
     ggtitle('b')


suppressWarnings(
     ggarrange(a, b, ncol = 2, nrow = 1,legend = "none") %>%
          grid.arrange(get_legend(a), heights = unit(c(80, 5), "mm"))
)

tiff('../plots/fig1.tiff', width = 13, height = 10, units = 'cm', res = 600)
ggarrange(a, b, ncol = 2, nrow = 1,legend = "none") %>%
     grid.arrange(get_legend(a), heights = unit(c(80, 5), "mm"))
dev.off()