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
#' @return ggplot2 fig with label added.
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
      c(
        "topleft",
        "topright",
        "left",
        "right",
        "bottom",
        "top",
        "centre",
        "bottomleft",
        "bottomright"
      )

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
