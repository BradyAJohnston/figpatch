#' Quickly arrange and label multiple figs.
#'
#' @param figs List of figs from \code{fig()}.
#' @param labelling Labels to be applied to figs. Begins with first uppercase or
#'   lowercase letter supplied, or number, and continues the sequence. "A"
#'   labels them 'A', 'B', etc. "c" labels them 'c', 'd', 'e' etc.
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
#' @param b_col Colour of individual fig borders.
#' @param b_size Size of individual fig borders (in mm).
#' @param b_pos Either "offset" and expanding outwards from borders of figure,
#'   or "inset" and expanding inwards and partially covering the figure.
#'
#' @return \code{patchwork} patch of supplied figs.
#' @export
#'
#' @examples
figwrap <- function(figs,
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
                    fontface = NULL,
                    b_col = NULL,
                    b_size = 1,
                    b_pos = "offset") {
  if (!is.list(figs)) {
    stop("figs must be a list of figs created by fig().")
  }

  num_figs <- length(figs)
  if (!is.null(labelling)) {
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
  }
  
  if (!is.null(labelling)) {
    labels <- paste0(prefix, labels, suffix)
  } else {
    labels <- NULL
  }

  figs <- lapply(seq_along(figs), function(x) {
    if (is.null(labels)) {
      fig <- figs[[x]]
    } else {
      fig <- figlab(
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
    }
    if (!is.null(b_col)) {
      if (b_pos == "offset") {
        fig <- fig +
          ggplot2::theme(
            panel.background = ggplot2::element_rect(
              colour = b_col,
              size = b_size
            )
          ) +
          ggplot2::coord_cartesian(clip = "off")
      } else if (b_pos == "inset") {
        fig <- fig +
          ggplot2::theme(
            panel.border = ggplot2::element_rect(
              fill = NA,
              colour = b_col,
              size = b_size
            )
          )
      } else {
        stop("border must be either 'inset' or 'offset'.")
      }
    }
    # Return the final fig to the list
    fig
  })
  # wrap the list of figs together
  patchwork::wrap_plots(figs, ncol = ncol, nrow = nrow)
}
