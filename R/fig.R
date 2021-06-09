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
#' @param b_margins Margins around the fig. Dimensions for top, right, bottom
#'   and left margins. Numeric vector of 1, 2 will be recycled for all 4
#'   dimensions.
#' @param b_unit Unit used for margins. Defaults to 'npc'. (see: ggplot2::unit())
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
           b_pos = "offset",
           b_margins = 0.01,
           b_unit = "npc") {
    if (grepl(".svg", path)) {
      warning("Currently .svg will be rasterised in the final plot.")
      img <- magick::image_read_svg(path)
    } else if (grepl(".pdf", path)) {
      warning("Currently .pdf will be rasterised in the final plot.")
      img <- magick::image_read_pdf(path)
    } else {
      img <- magick::image_read(path = path)
    }

    # extract image dimensions
    x_dim <- magick::image_info(img)$width
    y_dim <- magick::image_info(img)$height

    # Set aspect.ratio based on image dimensions or supplied values
    if (AR == "default") {
      AR <- y_dim / x_dim
    } else if (AR == "resize") {
      AR <- NULL
    } else if (!is.numeric(AR)) {
      stop("Aspect ratio (AR) must be either 'default', or a valid numeric number.")
    }

    # create actual fig
    fig <- ggplot2::ggplot() +
      ggplot2::annotation_custom(grid::rasterGrob(
        image = img,
        interpolate = TRUE,
        width = ggplot2::unit(1, "npc"),
        height = ggplot2::unit(1, "npc")
      )) +
      ggplot2::theme(
        aspect.ratio = AR
      ) +
      fig_margins(b_margins, b_unit)

    # Add a border to the fig. Border can be offset (expand from the outside
    # of the fig, or inset and expand into the centre of the fig, partially
    # covering some of the fig.)
    fig <- fig_borders(fig, b_col, b_pos, b_size)

    # Return the final fig.
    fig
  }