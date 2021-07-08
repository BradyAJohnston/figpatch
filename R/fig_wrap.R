#' Quickly arrange and label multiple figs.
#'
#' @param figs List of figs from \code{fig()}.
#' @param tag Tags to be applied to figs. Begins with first uppercase or
#'   lowercase letter supplied, or number, and continues the sequence. "A"
#'   labels them 'A', 'B', etc. "c" labels them 'c', 'd', 'e' etc.
#' @param prefix Prefix for each tag
#' @param suffix Suffix for each tag
#' @param pos Position for label, to be passed to \code{fig_tag()}.
#' @param colour Colour for each tag
#' @param alpha Alpha for each tag
#' @param hjust hjust for each tag
#' @param vjust vjust for each tag
#' @param fontsize Fontsize for each tag
#' @param fontfamily Fontfamily for each tag
#' @param fontface Fontface for each tag
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
#' @param b_margin Margins to adjust around the figs. Use
#'   \code{ggplot2::margin()}
#'
#' @return \code{patchwork} patch of supplied figs.
#' @export
#'
#' @examples
#'
#' library(figpatch)
#' library(ggplot2)
#'
#' # Attach the fig image file
#' image <- system.file("extdata", "fig.png", package = "figpatch", mustWork = TRUE)
#'
#' # Read in the image as a 'fig'
#' img <- fig(image)
#'
#' # multiple figs
#' figs <- lapply(1:9, function(x) img)
#'
#' # wrap the figs
#' fig_wrap(figs)
#'
#' # Wrap the figs and auto-tag
#' fig_wrap(figs, tag = "A", suffix = ")")
#'
#' # Wrap figs, auto-tag and adds border.
#' fig_wrap(figs, tag = 1, prefix = "(", suffix = ")", b_col = "black")
fig_wrap <- function(figs,
                     tag = NULL,
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
                     b_pos = "offset",
                     b_margin = ggplot2::margin(4, 4, 4, 4)) {
  # check if list
  if (!is.list(figs)) {
    stop("figs must be a list of figs created by fig().")
  }

  # count number of supplied figs
  num_figs <- length(figs)

  # check what tags are supplied
  if (!is.null(tag)) {
    if (length(tag) > 1) {
      if (length(tag) != length(figs)) {
        stop("If providing a tag vector, it must be of equal length to the number of figs.")
      }
    } else if (grepl("[[:upper:]]", tag)) {
      start_let <- grep(tag, LETTERS)
      tags <- LETTERS[seq(start_let, start_let + num_figs)]
    } else if (grepl("[[:lower:]]", tag)) {
      start_let <- grep(tag, letters)
      tags <- letters[seq(start_let, start_let + num_figs)]
    } else if (is.numeric(tag)) {
      tags <- seq(tag, tag + num_figs)
    }
  }


  if (!is.null(tag)) {
    tags <- paste0(prefix, tags, suffix)
  } else {
    tags <- NULL
  }
  figs <- lapply(seq_along(figs), function(x) {
    if (is.null(tags)) {
      fig <- figs[[x]]
    } else {
      fig <- fig_tag(
        plot = figs[[x]],
        tag = tags[x],
        pos = pos,
        x_nudge = repeat_value(x_nudge, num_figs, int = x),
        y_nudge = repeat_value(y_nudge, num_figs, int = x),
        colour = repeat_value(colour, num_figs, int = x),
        alpha = repeat_value(alpha, num_figs, int = x),
        hjust = repeat_value(hjust, num_figs, int = x),
        vjust = repeat_value(vjust, num_figs, int = x),
        fontsize = repeat_value(fontsize, num_figs, int = x),
        fontfamily = repeat_value(fontfamily, num_figs, int = x),
        fontface = repeat_value(fontface, num_figs, int = x)
      )
    }

    # apply borders if specified
    fig <- fig_borders(
      fig = fig,
      b_col = repeat_value(b_col, num_figs, int = x),
      b_pos = repeat_value(b_pos, num_figs, int = x),
      b_size = repeat_value(b_size, num_figs, int = x)
    )

    # Apply specified margins
    if (!is.null(b_margin)) {
      fig <- fig +
        ggplot2::theme(
          # aspect.ratio = aspect.ratio,
          plot.margin = b_margin
        )
    }

    # Return the final fig to the list
    fig
  })

  # wrap the list of figs together
  patchwork::wrap_plots(figs, ncol = ncol, nrow = nrow)
}
