#' Wraper function for @code mcmc_intervals (function from bayesplot)
#' @param x A dataset as produced by mcmc_intervals()$data
#' @param pars Parameters of the dataset to be used in the plot
#' @param regex_pars Same as the previous, but using regular expressions
#' @param prob A numeric indicating the quantile represented by the inner bars
#' @param prob_outer A numeric indicating the quantile represented by the outer bars
#' @param point_est A character indicating which point estimate to use as a central point of the distribution
#' @param outer_size Numeric indicating size (thickness) of the outer line
#' @param inner_size Numeric indicating size (thickness) of the inner line
#' @param point_size Numeric, size of the central point
#' @param vlines Numeric indicating the x intercepts for vertical line(s), if any
#' @return Plot of the distribution of coefficients / predictions passed to @param x

custom_intervals <- function (x, pars = character(), regex_pars = character(), transformations = list(), 
                              ..., prob = 0.5, prob_outer = 0.95, point_est = c("median", 
                                                                               "mean", "none"), outer_size = 0.5, inner_size = 2, 
                              point_size = 4, rhat = numeric(), vlines = NULL) 
{
     colors <- color_scheme_get()
     data <- x
     color_by_rhat <- rlang::has_name(data, "rhat_rating")
     no_point_est <- all(data$point_est == "none")
     x_lim <- range(c(data$ll, data$hh))
     x_range <- diff(x_lim)
     x_lim[1] <- x_lim[1] - 0.05 * x_range
     x_lim[2] <- x_lim[2] + 0.05 * x_range
     layer_vertical_line <- if (0 > x_lim[1] && 0 < x_lim[2]) {
          vline_0(color = "gray70", size = 0.9, linetype = 1)
     }
     
     args_outer <- list(mapping = aes_(x = ~ll, xend = ~hh, y = ~parameter, 
                                       yend = ~parameter), color = colors[3], size = outer_size)
     args_inner <- list(mapping = aes_(x = ~l, xend = ~h, y = ~parameter, 
                                       yend = ~parameter), size = inner_size, show.legend = FALSE)
     args_point <- list(mapping = aes_(x = ~m, y = ~parameter), 
                        data = data, size = point_size, shape = 21)
     if (color_by_rhat) {
          args_inner$mapping <- args_inner$mapping %>% modify_aes_(color = ~rhat_rating)
          args_point$mapping <- args_point$mapping %>% modify_aes_(color = ~rhat_rating, 
                                                                   fill = ~rhat_rating)
     }
     else {
          args_inner$color <- colors[5]
          args_point$color <- colors[6]
          args_point$fill <- colors[1]
     }
     point_func <- if (no_point_est) 
          print('Data is Wrong !')
     else geom_point
     layer_outer <- do.call(geom_segment, args_outer)
     layer_inner <- do.call(geom_segment, args_inner)
     layer_point <- do.call(point_func, args_point)
     if (color_by_rhat) {
          scale_color <- scale_color_diagnostic("rhat")
          scale_fill <- scale_fill_diagnostic("rhat")
     }
     else {
          scale_color <- scale_color_viridis()
          scale_fill <- scale_fill_viridis()
     }
     pl <- ggplot(data)
     if(!is.null(vlines)){
          pl <- pl +  geom_vline(xintercept = vlines, color = "gray70", size = 0.9, linetype = 2)
     }
     pl + layer_vertical_line + layer_outer + layer_inner + 
          layer_point + scale_color + scale_fill + scale_y_discrete(limits = unique(rev(data$parameter))) + 
          xlim(x_lim) + bayesplot_theme_get() + legend_move(ifelse(color_by_rhat, 
                                                                   "top", "none")) + yaxis_text(face = "bold") + 
          yaxis_title(FALSE) + yaxis_ticks(size = 1) + xaxis_title(FALSE)
}


#' Maps a colourful map of coordinates, in a heat-like pattern
#' @param xy A set of coordinates (matrix or data.frame) with column names x and y
#' @param mapping_data Data.frame of variables to map
#' @param quant An integer, number of quantiles (breaks, colors) to plot
#' @param qmap.pltt Palette to use for continuous variables
#' @param which.factor Integer, indices of the columns in @param mapping_data which should be treated as factors
#' @param factor.pltt Palette to use for categorical variables
#' @param labels Character vector to change the names of the variables passed in @param mapping_data
#' @return A list of plots, with as many elements as passed in @param mapping_data
qMap <- function(xy, mapping_data,quant = 8, qmap.pltt = mixOmics::color.jet,
                 which.factor = NULL, factor.pltt = viridis, labels = NULL){
     if(is.matrix(xy)){
          xy <- as.data.frame(xy)
          colnames(xy) <- c('x', 'y')
     }
     
     xy <- cbind.data.frame(xy, mapping_data)
     if(!length(labels)) labels <- colnames(mapping_data)
     
     pl <- vector('list', ncol(mapping_data))
     for(i in seq_len(sum(!colnames(mapping_data) %in% c('x', 'y')))){
          
          
          if(i %in% which.factor){
               factorized_var <- factor(mapping_data[, i])
               plt <- factor.pltt(length(unique(factorized_var)))
          } else {
               factorized_var <- cut(mapping_data[, i],
                                     breaks = unique(quantile(mapping_data[, i],
                                                              probs = seq(0, 1, length.out = quant + 1), na.rm = T)),
                                     include.lowest = T)
               plt <- qmap.pltt(length(unique(factorized_var)))
          }
          
          data <- data.frame(x = xy$x, y = xy$y, c = factorized_var)
          
          pl[[i]] <- ggplot(data = data, aes(x, y, color = c)) +
               geom_point(alpha = 0.5) + scale_color_manual(labels[i], values = plt,
                                                            labels = gsub(',', ', ', levels(factorized_var)),
                                                            guide = guide_legend(override.aes = list(alpha = 1))) +
               xlab('') + ylab('') + theme(aspect.ratio = 1)
          
          
     }
     names(pl) <- colnames(mapping_data)
     return(pl)
}
