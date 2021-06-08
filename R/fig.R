#' Create a fig.
#' Read image and convert to ggplot object, for use with other ggplot objects
#' when assembling with the \code{{patchwork}} package. Can also specify a border.
#'
#' @param path Path to image file.
#' @param AR Aspect ratio. 'default' inherits image's aspect ratio.
#' @param b_pos Whether the border is 'offset' (expands out from figure) or
#'   'inset' and expands inwards, partially covering up the figure.
#' @param b_col Colour of the border line.
#' @param b_size Size of the border line.
#'
#' @return ggplot2 plot with external figure.
#' @export
#'
#' @examples
fig <-
  function(path,
           AR = "default",
           b_col = NULL,
           b_size = 1,
           b_pos = "offset") {
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
    fig <- ggplot2::ggplot() +
      ggplot2::annotation_custom(grid::rasterGrob(
        image = img,
        interpolate = TRUE,
        width = ggplot2::unit(1, "npc"),
        height = ggplot2::unit(1, "npc")
      )) +
    ggplot2::theme(
      aspect.ratio = AR
    )

    # Add a border to the fig. Border can be offset (expand from the outside
    # of the fig, or inset and expand into the centre of the fig, partially
    # covering some of the fig.)
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
    fig
  }
