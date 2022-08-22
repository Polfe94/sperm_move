setwd('~/sperm_move/data')

xyz <- read.csv('pakde_ejaculates.csv')
lns <- read.csv('cluster_borders.csv')

library(reshape2)
library(ggplot2)

colnames(xyz) <- gsub('X', '', colnames(xyz))
ejac_sel <- colnames(xyz)[!colnames(xyz) %in% c('x', 'y')]

# custom labeller function
labeller <- function(x = ejac_sel, l1 = 'Boar ', l2 = 'Ejaculate 1'){
     ejac_labels <- c()
     for(i in 1:length(x)){
          if(nchar(x[i]) == 4){
               current <- paste(l1, substr(x[i], 1, 1), ' - ', l2, sep = '')
          } else {
               current <- paste(l1, substr(x[i], 1, 2), ' - ', l2, sep = '')
          }
          ejac_labels <- c(ejac_labels, current)
     }
     for(i in unique(ejac_labels)){
          sbst <- ejac_labels[ejac_labels == i]
          if(length(sbst) > 1){
               correct <- c()
               for(dpl in 1:sum(duplicated(sbst))){
                    correct <- c(correct, paste(substr(sbst[dpl+1], 1, nchar(sbst[dpl+1])-1),
                                                as.numeric(substr(sbst[dpl+1], nchar(sbst[dpl+1]), nchar(sbst[dpl+1]))) +dpl,
                                                sep='')
                    )
               }
               correct <- c(sbst[1], correct)
               ejac_labels[ejac_labels == i] <- correct
          }
     }
     names(ejac_labels) <- x
     return(ejac_labels)
}
ejac_labels <- labeller(x = ejac_sel)

mlt_xyz <- melt(xyz, id.vars = c('x', 'y'))
colnames(mlt_xyz) <- c('x', 'y', 'ejaculate', 'z')
mlt_xyz$ejaculate <- as.character(mlt_xyz$ejaculate)

for(i in 1:length(ejac_labels)){
     mlt_xyz$ejaculate[mlt_xyz$ejaculate == names(ejac_labels)[i]] <- ejac_labels[i]
}
mlt_xyz$ejaculate <- factor(mlt_xyz$ejaculate, levels = ejac_labels)
mlt_xyz$z[mlt_xyz$z < quantile(mlt_xyz$z, probs = 0.5)] <- NA

A <- ggplot(data = mlt_xyz) + geom_raster(aes(x = x, y = y, fill = z)) + 
     
     scale_fill_gradientn('Density', colors = mixOmics::color.jet(200), na.value = 'white') + 
     theme_classic() +
     geom_contour(aes(x, y, z = z), bins = 10, color = 'grey99', alpha = 0.4) + 
     facet_wrap(~ ejaculate, ncol = 3, nrow = 4) + xlab('') + ylab('') +
     geom_point(data = lns, aes(x, y), color = 'white', size = 0.0001, alpha = 0.07)+
     theme(axis.text.x = element_text(size = 15),
           axis.text.y = element_text(size = 15),
           legend.text = element_text(size = 15),
           legend.title = element_text(size = 17),
           strip.text = element_text(size = 15),
           aspect.ratio = 1)

tiff('../plots/figS3.tiff', 7680, 6400, res = 600)
A
dev.off()
