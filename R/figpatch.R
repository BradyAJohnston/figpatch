#' img2plot
#' Convert image to ggplot object with given aspect ratio.
#'
#' @param path Path to image file. 
#' @param AR Aspect ratio. 'default' inherits image's aspect ratio.
#' @param colour Colour of rectangle around image. (Uses plot.background in theme)
#' @param fill Fill of rectange around image. (uses plot.background in theme)
#'
#' @return
#' @export
#'
#' @examples
img2plot <-
  function(path,
           AR = "default",
           colour = NULL,
           fill = NULL) {
    img <- magick::image_read(path = path)
    
    x_dim <- magick::image_info(img)$width
    y_dim <- magick::image_info(img)$height
    
    if (AR == "default") {
      AR <- y_dim / x_dim
    } else if (AR == "resize") {
      AR <- NULL
    } else if (!is.numeric(AR)) {
      stop("Aspect ratio (AR) must be either 'default', or a valid numeric number.")
    }
    
    ggplot2::ggplot() +
      ggplot2::annotation_custom(grid::rasterGrob(
        img,
        width = ggplot2::unit(1, "npc"),
        height = ggplot2::unit(1, "npc")
      )) +
      ggplot2::theme(
        aspect.ratio = AR,
        plot.background = ggplot2::element_rect(colour = colour,
                                                fill = fill)
      )
  }

#' Label img2plot plot.
#'
#' @param plot Plot from img2plot function.
#' @param lab Label to add to plot.
#' @param pos Position of label (Default 'topleft').
#' @param hjust hjust of plot label.
#' @param vjust vjust of plot label.
#' @param fontsize Fontsize of plot label.
#' @param fontfamily Fontfamily of plot label.
#'
#' @return
#' @export
#'
#' @examples
plotlab <-
  function(plot,
           lab,
           pos = "topleft",
           hjust = 0,
           vjust = 1,
           fontsize = 20,
           fontfamily = NULL) {
    xpos <- c("topleft" = 0)
    ypos <- c("topleft" = 1)
    
    xpos <- xpos[pos]
    ypos <- ypos[pos]
    
    plot + ggplot2::annotation_custom(
      grid::textGrob(
        label = lab,
        x = grid::unit(xpos, "npc"),
        y = grid::unit(ypos, "npc"),
        hjust = hjust,
        vjust = vjust,
        gp = grid::gpar(fontsize = fontsize,
                        fontfamily = fontfamily)
      )
    )
  }