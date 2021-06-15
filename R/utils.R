#' Creating margins for figs.
#'
#' @noRd
fig_margins <- function(b_margins, b_unit, aspect.ratio = NULL) {
  # calculate border values (t,r,b,l)
  if (is.null(b_margins)) {
    NULL
  } else {
    if (!is.numeric(b_margins)) {
      stop("b_margins must be a numeric vector of length 1, 2, or 4.")
    }
    if (length(b_margins == 1)) {
      b_margins <- rep(b_margins, 4)
    } else if (length(b_margins == 2)) {
      b_margins <- rep(b_margins, 2)
    } else if (length(b_margins == 4)) {
      b_margins <- b_margins
    } else {
      stop("b_margins must be a numeric vector of length 1, 2, or 4.")
    }

    # adjust margins to account foraspect.ratioof image.
    if (is.null(aspect.ratio)) aspect.ratio <- 1
    b_margins <- b_margins * c(1, aspect.ratio, 1, aspect.ratio)

    if (is.null(b_unit)) {
      b_unit <- "npc"
    }
    ggplot2::theme(
      plot.margin = ggplot2::unit(b_margins, b_unit)
    )
  }
}

#' Adding borders to plots.
#'
#'
#' @noRd
fig_borders <- function(fig, b_col, b_pos, b_size) {
  if (!is.null(b_col)) {
    if (b_pos == "offset") {
      suppressWarnings(
        fig <- fig +
          ggplot2::theme(
            panel.background = ggplot2::element_rect(
              colour = b_col,
              size = b_size
            )
          ) +
          ggplot2::coord_cartesian(clip = "off")
      )
    } else if (b_pos == "inset") {
      suppressWarnings(
        fig <- fig +
          ggplot2::theme(
            panel.border = ggplot2::element_rect(
              fill = NA,
              colour = b_col,
              size = b_size
            )
          )
      )
    } else {
      stop("border must be either 'inset' or 'offset'.")
    }
  }
  fig
}

#' Repeat a value if needed
#'
#'
#' @noRd
repeat_value <- function(value, times, int) {
  if (is.null(value)) {
    return(value)
  }
  if (length(value) != 1) {
    if (length(value) != times) {
      stop(
        paste0(
          "Length of ", deparse(substitute(value)), " must be either of length 1",
          " or equal to number of supplied figs."
        )
      )
    } else {
      value[int]
    }
  } else {
    value
  }
}
