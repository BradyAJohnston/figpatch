#' Add Label to a Fig
#'
#' @param fig Fig to be labelled.
#' @param lab String of label to be added to the fig.
#' @param pos Position of the fig, either 'top', 'bottom', 'left', or 'right'.
#' @param margin Margin around the label text. Use \code{ggplot2::margin()}
#' @param fontfamily Font family for the label.
#' @param fontface Font face for the label (i.e. "italic")
#' @param colour Colour of the label text.
#' @param size Size of the label text.
#' @param hjust hjust of the label text.
#' @param vjust vjust of the label text.
#' @param angle Angle of the label text.
#' @param lineheight Lineheight of the label text.
#'
#' @return \code{\{ggplot2\}} object
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
#' # add the fig label
#' fig_lab(
#'   img,
#'   lab = "Below you will find a fig!",
#'   pos = "top",
#'   size = 20
#' )
fig_lab <- function(fig,
                    lab,
                    pos = "bottom",
                    fontfamily = NULL,
                    fontface = NULL,
                    colour = NULL,
                    size = NULL,
                    lineheight = NULL,
                    hjust = NULL,
                    vjust = NULL,
                    angle = NULL,
                    margin = ggplot2::margin(4, 4, 4, 4)) {
  if (pos == "bottom") {
    fig +
      ggplot2::labs(
        x = lab
      ) +
      ggplot2::theme(
        axis.title.x.bottom = ggplot2::element_text(
          family = fontfamily,
          face = fontface,
          colour = colour,
          size = size,
          lineheight = lineheight,
          hjust = hjust,
          vjust = vjust,
          angle = angle,
          margin = margin
        )
      )
  } else if (pos == "top") {
    fig +
      ggplot2::labs(
        x = lab
      ) +
      ggplot2::scale_x_continuous(position = "top") +
      ggplot2::theme(
        axis.title.x.top = ggplot2::element_text(
          family = fontfamily,
          face = fontface,
          colour = colour,
          size = size,
          lineheight = lineheight,
          hjust = hjust,
          vjust = vjust,
          angle = angle,
          margin = margin
        )
      )
  } else if (pos == "left") {
    fig +
      ggplot2::labs(
        y = lab
      ) +
      ggplot2::theme(
        axis.title.y.left = ggplot2::element_text(
          family = fontfamily,
          face = fontface,
          colour = colour,
          size = size,
          lineheight = lineheight,
          hjust = hjust,
          vjust = vjust,
          angle = angle,
          margin = margin
        )
      )
  } else if (pos == "right") {
    fig +
      ggplot2::labs(
        y = lab
      ) +
      ggplot2::scale_y_continuous(position = "right") +
      ggplot2::theme(
        axis.title.x.right = ggplot2::element_text(
          family = fontfamily,
          face = fontface,
          colour = colour,
          size = size,
          lineheight = lineheight,
          hjust = hjust,
          vjust = vjust,
          angle = angle,
          margin = margin
        )
      )
  } else {
    stop("pos must be either bottom, top, left or right.")
  }
}
