#' Parse Image to a Fig
#'
#' Read image and convert to ggplot object, for use with other ggplot objects
#' when assembling with the \code{{patchwork}} package. Can also specify a border.
#'
#' @param path Path to image file.
#' @param aspect.ratio Manually override the image's aspect ratio or set "free" to allow fig
#'   to be resized by patchwork.
#' @param b_pos Whether the border is 'offset' (expands out from figure) or
#'   'inset' and expands inwards, partially covering up the figure.
#' @param b_col Colour of the border line.
#' @param b_size Size of the border line.
#' @param b_margin Margin around the fig. Use \code{ggplot2::margin()}
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
#' img
fig <-
  function(path,
           aspect.ratio = "default",
           b_col = NULL,
           b_size = 1,
           b_pos = "offset",
           b_margin = ggplot2::margin(4, 4, 4, 4)) {

    # read in specified image
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
    if (aspect.ratio == "default") {
      aspect.ratio <- y_dim / x_dim
    } else if (aspect.ratio == "free") {
      aspect.ratio <- NULL
    } else if (!is.numeric(aspect.ratio)) {
      stop("aspect.ratio must be either 'default', 'free', or a valid numeric number.")
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
        aspect.ratio = aspect.ratio,
        plot.margin = b_margin
      )

    # Add a border to the fig. Border can be offset (expand from the outside
    # of the fig, or inset and expand into the centre of the fig, partially
    # covering some of the fig.)
    fig <- fig_borders(fig, b_col, b_pos, b_size)

    # Return the final fig.
    fig
  }
