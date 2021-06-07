#' Create a fig.
#' Read image and convert to ggplot object, for use with other ggplot objects
#' when assembling with the \code{{patchwork}} package.
#'
#' @param path Path to image file.
#' @param AR Aspect ratio. 'default' inherits image's aspect ratio.
#' @param colour Colour of rectangle around image. (Uses plot.background in theme)
#' @param fill Fill of rectangle around image. (uses plot.background in theme)
#'
#' @return
#' @export
#'
#' @examples
fig <-
  function(path,
           AR = "default",
           colour = NULL,
           fill = NULL) {
    
    if (grepl(".svg", path)) {
      warning("Currently .svg will be rasterised in the final plot.")
      img <- magick::image_read_svg(path)
    } else if (grepl(".pdf", path)) {
      warning("Currently .pdf will be rasterised in the final plot.")
      img <- magick::image_read_pdf(path)
    } else {
      img <- magick::image_read(path = path)
    }

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
        image = img,
        interpolate = TRUE,
        width = ggplot2::unit(1, "npc"),
        height = ggplot2::unit(1, "npc")
      )) +
      ggplot2::theme(
        aspect.ratio = AR,
        plot.background = ggplot2::element_rect(
          colour = colour,
          fill = fill
        )
      )
  }

#' Add a label to a fig.
#'
#' @param plot Plot from img2plot function.
#' @param lab Label to add to plot.
#' @param pos Position of label (Default 'topleft').
#' @param hjust hjust of plot label.
#' @param vjust vjust of plot label.
#' @param fontsize Fontsize of laebl (in points).
#' @param fontfamily Fontfamily of plot label.
#' @param colour Colour of label text.
#' @param alpha Alpha of label text.
#' @param fontface The font face (bolt, italic, ...)
#' @param x_nudge Minor adjustments to the x position in relative plot
#'   coordindates (0 being furthest left, 1 being furthest right).
#' @param y_nudge Minor adjustments to the y position in relative plot
#'   coordinates (0 being the bottom, 1 being the top).
#'
#' @return
#' @export
#'
#' @examples
figlab <-
  function(plot,
           lab,
           pos = "topleft",
           x_nudge = 0, 
           y_nudge = 0,
           colour = NULL,
           alpha = NULL,
           hjust = NULL,
           vjust = NULL,
           fontsize = 12,
           fontface = NULL,
           fontfamily = NULL) {
    
    if ("aspect.ratio" %in% names(plot$theme)) {
      AR <- plot$theme$aspect.ratio
    } else {
      AR <- 1
    }
    
    # Possible default positions
    positions <-
      c("topleft",
        "topright",
        "left",
        "right", 
        "bottom", 
        "top",
        "centre",
        "bottomleft",
        "bottomright")
    
    # Lookups for the different default labelling positions
    xpos_lookup <- c(
      "topleft" = 0.05 * AR,
      "topright" = 1 - (0.05 * AR),
      "top" = 0.5, 
      "bottom" = 0.5,
      "left" = 0.05 * AR,
      "right" = 1 - (0.05 * AR),
      "centre" = 0.5,
      "bottomleft" = 0.05 * AR,
      "bottomright" = 1 - (0.05 * AR)
    )
    ypos_lookup <- c(
      "topleft" = 0.95,
      "topright" = 0.95,
      "top" = 0.95, 
      "bottom" = 0.05,
      "left" = 0.5,
      "right" = 0.5,
      "centre" = 0.5,
      "bottomleft" = 0.05,
      "bottomright" = 0.05
    )
    hjust_lookup <- c(
      "topleft" = 0,
      "topright" = 1,
      "top" = 0.5, 
      "bottom" = 0.5,
      "left" = 0,
      "right" = 1,
      "centre" = 0.5,
      "bottomleft" = 0,
      "bottomright" = 1
    )
    vjust_lookup <- c(
      "topleft" = 1,
      "topright" = 1,
      "top" = 1, 
      "bottom" = 0,
      "left" = 0.5,
      "right" = 0.5,
      "centre" = 0.5,
      "bottomleft" = 0,
      "bottomright" = 0
    )
    

    
    if (is.character(pos)) {
      if (pos %in% positions) {
        xpos <- xpos_lookup[pos]
        ypos <- ypos_lookup[pos]
        
        if (is.null(hjust)) hjust <- hjust_lookup[pos]
        if (is.null(vjust)) vjust <- vjust_lookup[pos]
        
      } else {
        stop(
          paste(
            "Character string does not match one of the possible defaults:", 
            paste(positions, collapse = ", "), 
            collapse = " "
          )
        )
      }
    } else if (is.numeric(pos)) {
      if (length(pos) == 2) {
        xpos <- pos[1]
        ypos <- pos[2]
      } else {
          stop(
            paste(
              "Position must be either a numeric vector of length 2 c(xpos, ypos) or a",
              "character vector matching one of the possible defaults:",
              paste(positions, collapse = ", "), 
              collapse = " "
            )
          )
        }
    }
    
    xpos <- xpos + x_nudge * AR
    ypos <- ypos + y_nudge
    
    plot + ggplot2::annotation_custom(
      grid::textGrob(
        label = lab,
        x = grid::unit(xpos, "npc"),
        y = grid::unit(ypos, "npc"),
        hjust = hjust,
        vjust = vjust,
        gp = grid::gpar(
          fontsize = fontsize,
          fontfamily = fontfamily,
          fontface = fontface,
          col = colour,
          alpha = alpha
        )
      )
    )
  }

#' Quickly arrange and label multiple figs.
#'
#' @param figs List of figs from \code{fig()}.
#' @param labelling 
#' @param prefix Prefix for each label.
#' @param suffix Suffix for each label.
#' @param pos Position for label, to be passed to \code{figlab()}.
#' @param colour Colour for each label.
#' @param alpha Alpha for each label.
#' @param hjust hjust for each label.
#' @param vjust vjust for each label.
#' @param fontsize Fontsize for each label.
#' @param fontfamily Fontfamily for each label.
#' @param fontface Fontface for each label.
#' @param nrow Number of rows in final patchwork.
#' @param ncol Number of cols in final patchwork.
#' @param x_nudge Minor adjustments to the x position in relative plot
#'   coordindates (0 being furthest left, 1 being furthest right).
#' @param y_nudge Minor adjustments to the y position in relative plot
#'   coordinates (0 being the bottom, 1 being the top).
#'
#' @return
#' @export
#'
#' @examples
figwrap <- function(
  figs, 
  labelling = NULL, 
  prefix = NULL, 
  suffix = NULL, 
  pos = "topleft", 
  x_nudge = 0, 
  y_nudge = 0,
  nrow = NULL, 
  ncol = NULL,
  colour = NULL, 
  alpha = NULL, 
  hjust = NULL, 
  vjust = NULL, 
  fontsize = NULL, 
  fontfamily = NULL, 
  fontface = NULL
) {
  if (!is.list(figs)) {
    stop("figs must be a list of figs created by fig().")
  }
  
  num_figs <- length(figs)
  
  if (length(labelling) > 1) {
    if (length(labelling) != length(figs)) {
      stop("If providing a labelling vector, it must be of equal length to the number of figs.")
    }
  } else if (grepl("[[:upper:]]", labelling)) {
    start_let <- grep(labelling, LETTERS)
    labels <- LETTERS[seq(start_let, start_let + num_figs)]
  } else if (grepl("[[:lower:]]", labelling)) {
    start_let <- grep(labelling, letters)
    labels <- letters[seq(start_let, start_let + num_figs)]
  } else if (is.numeric(labelling)) {
    labels <- seq(labelling, labelling + num_figs)
  }
  
  labels <- paste0(prefix, labels, suffix)
  
  figs <- lapply(seq_along(figs), function(x) {
    figlab(
      plot = figs[[x]], 
      lab = labels[x], 
      pos = pos, 
      x_nudge = x_nudge,
      y_nudge = y_nudge,
      colour = colour, 
      alpha = alpha, 
      hjust = hjust, 
      vjust = vjust, 
      fontsize = fontsize, 
      fontfamily = fontfamily, 
      fontface = fontface
      )
  })
  
  patchwork::wrap_plots(figs, ncol = ncol, nrow = nrow)
  
}