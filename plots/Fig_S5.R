setwd('~/sperm_move/data')

knp <- read.csv('knp.csv')

library(ggplot2)
library(ggpubr)
library(gridExtra)

a <- ggplot(data = knp, aes(k, q, color = factor(ppx))) + geom_point(size = 3.5, show.legend = F) + geom_line(show.legend = F) +
        scale_color_viridis_d('Perplexity', labels = c('64 (0.1 %)',
                                                       '320 (0.5 %)',
                                                       '639 (1.0 %)',
                                                       '3197 (5.0 %)',
                                                       '6393 (10.0 %)')) +
        xlab(expression(paste('K')))+ ylab('K-ary Neighbor Preservation')+
        theme_classic()+ scale_x_continuous(labels = c(0, expression(paste(2 ,'·' ,10^4)),
                                                       expression(paste(4 ,'·' ,10^4)),
                                                       expression(paste(6 ,'·' ,10^4)))) +
        theme(axis.title = element_text(size = 20), axis.text = element_text(size = 18, color = 'black'),
              legend.text = element_text(size = 18), legend.title = element_text(size = 20),
              title = element_text(color = 'black', size = 20, face = 'bold'), aspect.ratio = 1,
              legend.position = 'none') +
        guides(color = guide_legend(override.aes = list(size = 4.5))) +
        ggtitle('a')

b <- ggplot(data = knp, aes(log(k, 10), q, color = factor(ppx))) + geom_point(size = 3.5) + geom_line(show.legend = F) +
        scale_color_viridis_d('Perplexity', labels = c('64 (0.1 %)',
                                                       '320 (0.5 %)',
                                                       '639 (1.0 %)',
                                                       '3197 (5.0 %)',
                                                       '6393 (10.0 %)')) +
        xlab(expression(paste(log[10](K))))+ ylab('')+
        theme_classic()+ 
        theme(axis.title = element_text(size = 20), axis.text = element_text(size = 18, color = 'black'),
              legend.text = element_text(size = 18), legend.title = element_text(size = 20),
              title = element_text(color = 'black', size = 20, face = 'bold'), 
              axis.line.y = element_line(color = 'white'), axis.ticks.y = element_line(color = 'white'),
              axis.text.y = element_text(color = 'white'),aspect.ratio = 1) + 
        guides(color = guide_legend(override.aes = list(size = 4.5)))+
        ggtitle('b')

leg <- ggpubr::get_legend(b)
b <- b + theme(legend.position = 'none')

tiff('../plots/figS5.tiff', width = 16 * 300, height = 9 * 300, res = 300)
gridExtra::grid.arrange(a,b, ncol = 2, right =leg)
dev.off()
