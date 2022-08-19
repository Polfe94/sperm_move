setwd('~/sperm_move/data')
source('../src/PLOT_FUNCTIONS.R')
lns <- read.csv('cluster_capacitated_borders.csv')
xyz <- read.csv('pakde_capacitated.csv')
sperm <- read.csv('capacitated_dataset.csv')

# library(bigMap)
library(ggplot2)
library(viridis)
library(ggpubr)
library(reshape2)
library(gridExtra)

ggplot2::theme_set(ggplot2::theme_void() %+replace% ggplot2::theme(legend.text = element_text(color = 'black', size = 20),
                                                                   legend.title = element_text(color = 'black', size = 21, face = 'bold'),
                                                                   plot.title = element_text(color = 'black', size = 25, face = 'bold')))



mlt_xyz <- melt(xyz[, 1:5], id.vars = c('x', 'y', 'hardC'))
colnames(mlt_xyz) <- c('x', 'y', 'hK', 'Condition', 'z')
mlt_xyz$Condition <- as.character(mlt_xyz$Condition)
mlt_xyz$Condition <- factor(mlt_xyz$Condition, levels = c('Capacitated', 'Fresh'))
mlt_xyz <- mlt_xyz[!is.na(mlt_xyz$hK), ]

B <- ggplot(data = mlt_xyz) + geom_tile(aes(x = x, y = y, fill = factor(hK))) + 
        
        scale_fill_viridis_d('', begin = 0, end = 0.6, na.value ='white', labels = c('Fresh', 'Capacitated')) + 
        geom_point(data = lns, aes(x, y), color = 'white', size = 0.0001, alpha = 0.3)+
        theme_void() +
        theme(aspect.ratio = 1, legend.text = element_text(color = 'black', size = 20),
              plot.margin = unit(c(-1,0,-1,1), "cm"))+
        ggtitle('')


mlt_xyz <- melt(xyz[, c(1:2, 6:7)], id.vars = c('x', 'y'))
colnames(mlt_xyz) <- c('x', 'y', 'Condition', 'z')
mlt_xyz$Condition <- as.character(mlt_xyz$Condition)
mlt_xyz$Condition <- factor(mlt_xyz$Condition, levels = c('Capacitated', 'Fresh'))
mlt_xyz$z[mlt_xyz$z < quantile(mlt_xyz$z, probs = 0.7)] <- NA
mlt_xyz <- mlt_xyz[!is.na(mlt_xyz$z), ]
C1 <- ggplot(data = mlt_xyz[mlt_xyz$Condition == 'Capacitated', ]) + geom_tile(aes(x = x, y = y, fill = z)) + 
        
        scale_fill_gradientn('',colours = mixOmics::color.jet(200), na.value = 'white',
                             limits = c(min(mlt_xyz$z, na.rm = T), max(mlt_xyz$z, na.rm = T)),
                             breaks = c(min(mlt_xyz$z, na.rm = T), max(mlt_xyz$z, na.rm = T)),
                             labels = c('Low', 'High')) + 
        theme_void() +
        geom_contour(aes(x, y, z = z), bins = 10, color = 'grey99', alpha = 0.4) + 
        geom_point(data = lns, aes(x, y), color = 'white', size = 0.0001, alpha = 0.07)+
        theme(legend.text = element_text(size = 20),
              legend.title = element_text(size = 21),
              legend.position = 'bottom',
              aspect.ratio = 1, 
              plot.title = element_text(color = 'black', size = 27, face = 'bold', hjust = 0.1, vjust = -5),
              plot.margin = unit(c(-3.25,0,-2.5,1), "cm"))+
        ggtitle('c')

C2 <- ggplot(data = mlt_xyz[mlt_xyz$Condition == 'Fresh', ]) + geom_tile(aes(x = x, y = y, fill = z), show.legend = F) + 
        
        scale_fill_gradientn('',colours = mixOmics::color.jet(200), na.value = 'white',
                             limits = c(min(mlt_xyz$z, na.rm = T), max(mlt_xyz$z, na.rm = T)),
                             breaks = c(min(mlt_xyz$z, na.rm = T), max(mlt_xyz$z, na.rm = T)),
                             labels = c('Low', 'High')) + 
        theme_void() +
        geom_contour(aes(x, y, z = z), bins = 10, color = 'grey99', alpha = 0.4) + 
        geom_point(data = lns, aes(x, y), color = 'white', size = 0.0001, alpha = 0.07)+
        theme(legend.text = element_text(size = 20),
              legend.title = element_text(size = 21),
              aspect.ratio = 1, 
              plot.title = element_text(color = 'black', size = 27, face = 'bold'),
              plot.margin = unit(c(-3.25,0,-2.5,0), 'cm'))+
        ggtitle('')

C <- ggarrange(C1, C2, ncol = 2, nrow = 1,legend = "none") %>%
        grid.arrange(get_legend(C1), heights = unit(c(80, 5), "mm"))


pltt <- function(n, alpha = 1, begin = 0, end = 0.6, direction = - 1, option = 'D'){
        viridis(n = n, alpha = alpha, begin = begin, end = end, direction = direction, option = option)
}

qmap <- qMap(sperm[, c('x', 'y')], sperm[, -c(6,7)], which.factor = 5, factor.pltt = pltt)
qmap[[1]] <- qmap[[1]] + ggtitle('a') +
        theme(plot.title = element_text(hjust = 0.1, vjust = 1)) +
        guides(color = guide_legend(override.aes = list(size = 3, alpha = 1)))
qmap[[2]] <- qmap[[2]] + ggtitle('') + theme(plot.title = element_text(hjust = 0.1))+
        guides(color = guide_legend(override.aes = list(size = 3, alpha = 1)))
qmap[[3]] <- qmap[[3]] + ggtitle('')+ theme(plot.title = element_text(hjust = 0.1))+
        guides(color = guide_legend(override.aes = list(size = 3, alpha = 1)))
qmap[[4]] <- qmap[[4]] + ggtitle('')+ theme(plot.title = element_text(hjust = 0.1))+
        guides(color = guide_legend(override.aes = list(size = 3, alpha = 1)))
qmap[[5]] <- qmap[[5]] +ggtitle('b') +
        theme(plot.title = element_text(hjust = 0.1, vjust = -5),
              legend.position = 'none',
              plot.margin = unit(c(0,0,0,0), units = 'cm'),
              legend.title = element_text(size = 27, face = 'bold'))
qmap[[5]]$layers[[1]]$aes_params$size = 0.5


B <- ggarrange(qmap[[5]], B, ncol = 2, nrow = 1,legend = "none") %>%
        grid.arrange(get_legend(B), heights = unit(c(80, 5), "mm"))

A <- ggarrange(plotlist = qmap[1:4])

fig <- list(A, B, C)

png('C:/Users/POL/Desktop/FIGS_DEF/fig5.png', width = 400, height = 600, res = 50)
grid.arrange(grobs = fig, layout_matrix = rbind(c(1,1), c(1,1), c(2,2), c(3,3)))
dev.off()



tiff('C:/Users/POL/Desktop/FIGS_DEF/fig5.tiff', width = 5000, height = 8000, res = 520)
grid.arrange(grobs = fig, layout_matrix = rbind(c(1,1), c(1,1), c(2,2), c(3,3)))
dev.off()

png('C:/Users/pfern/Desktop/gPigs_WORK/figures_definitives/fig5A_v2.png', 2000, 1500, res = 200)
grid.arrange(fig[[1]])
dev.off()

png('C:/Users/pfern/Desktop/gPigs_WORK/figures_definitives/fig5B_v2.png', 4000, 4000, res = 400)
grid.arrange(grobs = fig[2:3], ncol = 1, nrow = 2)
dev.off()

# lay <- rbind(c(1,1,2,2),
#              c(1,1,3,3))
# png('~/research/gPigs/figures_definitives/fig5.png', 8200, 4000, res = 400)
# grid.arrange(grobs = fig, layout_matrix = lay)
# dev.off()

# ggplot(data = melt(fc[which(bdm.labels(p675) == 1), -5]), aes(variable, value)) + geom_boxplot() + theme_classic()
