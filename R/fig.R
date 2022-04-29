#' Parse Image to a Fig
#'
#' Read image and convert to ggplot object, for use with other ggplot objects
#' when assembling with the \code{{patchwork}} package. Can also specify a
#' border.
#'
#' @param path Path to image file.
#' @param aspect.ratio Manually override the image's aspect ratio or set "free"
#'   to allow fig to be resized by patchwork.
#' @param b_pos Whether the border is 'offset' (expands out from figure) or
#'   'inset' and expands inwards, partially covering up the figure.
#' @param b_col Colour of the border line.
#' @param b_size Size of the border line.
#' @param b_margin Margin around the fig. Use \code{ggplot2::margin()}
#' @param link_dim Logical, whether to lock the dimensions & aspect.ratio of the
#'   aligned plots to that of this fig.
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
           link_dim = TRUE,
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

    max_dim <- max(x_dim, y_dim)

    # Set aspect.ratio based on image dimensions or supplied values
    if (aspect.ratio == "default") {
      aspect.ratio <- y_dim / x_dim
    } else if (aspect.ratio == "free") {
      aspect.ratio <- NULL
    } else if (!is.numeric(aspect.ratio)) {
      stop("aspect.ratio must be either 'default', 'free', or a valid numeric number.")
    }


    if (link_dim) {
      # create actual fig
      fig <- ggplot2::ggplot() +
        ggplot2::annotation_custom(grid::rasterGrob(
          image = img,
          interpolate = TRUE,
          width = ggplot2::unit(1, "npc"),
          height = ggplot2::unit(1, "npc")
        )) +
        ggplot2::theme_void() +
        ggplot2::theme(
          aspect.ratio = aspect.ratio,
          plot.margin = b_margin
        )
    } else {
      (
        # create actual fig
        fig <- ggplot2::ggplot() +
          ggplot2::annotation_custom(grid::rasterGrob(
            image = img,
            interpolate = TRUE,
            width = ggplot2::unit(x_dim / max_dim, "snpc"),
            height = ggplot2::unit(y_dim / max_dim, "snpc")
          )) +
          ggplot2::theme_void() +
          ggplot2::theme(
            plot.margin = b_margin
          )

      )
    }


    # Add a border to the fig. Border can be offset (expand from the outside
    # of the fig, or inset and expand into the centre of the fig, partially
    # covering some of the fig.)
    fig <- fig_borders(fig, b_col, b_pos, b_size)

    # add on the dimensions of the figure, for later computations
    fig$fig_data <- list(
      img = img,
      aspect.ratio = aspect.ratio,
      link_dim = link_dim,
      b_col = b_col,
      b_size = b_size,
      b_pos = b_pos,
      b_margin = b_margin,
      x_dim = x_dim,
      y_dim = y_dim
    )

    # Return the final fig.
    fig
  }


#' @noRd
fig_update <-
  function(fig,
           max_x = 100,
           max_y = 100,
           aspect.ratio = "default",
           link_dim = TRUE,
           border_expand_colour = "white",
           b_col = NULL,
           b_size = 1,
           b_pos = "offset",
           b_margin = ggplot2::margin(4, 4, 4, 4)) {
    img <- fig$fig_data$img

    # extract image dimensions
    x_dim <- fig$fig_data$x_dim
    y_dim <- fig$fig_data$y_dim

    border_string <- paste0((max_x - x_dim) / 2, "x", (max_y - y_dim) / 2)

    img <- magick::image_border(img, color = border_expand_colour, geometry = border_string)


    x_dim <- max_x
    y_dim <- max_y

    max_dim <- max(x_dim, y_dim)


    # Set aspect.ratio based on image dimensions or supplied values
    if (aspect.ratio == "default") {
      aspect.ratio <- y_dim / x_dim
    } else if (aspect.ratio == "free") {
      aspect.ratio <- NULL
    } else if (!is.numeric(aspect.ratio)) {
      stop("aspect.ratio must be either 'default', 'free', or a valid numeric number.")
    }


    if (link_dim) {
      # create actual fig
      fig <- ggplot2::ggplot() +
        ggplot2::annotation_custom(grid::rasterGrob(
          image = img,
          interpolate = TRUE,
          width = ggplot2::unit(1, "npc"),
          height = ggplot2::unit(1, "npc")
        )) +
        ggplot2::theme_void() +
        ggplot2::theme(
          aspect.ratio = aspect.ratio,
          plot.margin = b_margin
        )
    } else {
      (
        # create actual fig
        fig <- ggplot2::ggplot() +
          ggplot2::annotation_custom(grid::rasterGrob(
            image = img,
            interpolate = TRUE,
            width = ggplot2::unit(x_dim / max_dim, "snpc"),
            height = ggplot2::unit(y_dim / max_dim, "snpc")
          )) +
          ggplot2::theme_void() +
          ggplot2::theme(
            plot.margin = b_margin
          )

      )
    }


    # Add a border to the fig. Border can be offset (expand from the outside
    # of the fig, or inset and expand into the centre of the fig, partially
    # covering some of the fig.)
    fig <- fig_borders(fig, b_col, b_pos, b_size)

    # add on the dimensions of the figure, for later computations
    fig$fig_data <- list(
      img = img,
      aspect.ratio = aspect.ratio,
      link_dim = link_dim,
      b_col = b_col,
      b_size = b_size,
      b_pos = b_pos,
      b_margin = b_margin,
      x_dim = x_dim,
      y_dim = y_dim
    )

    # Return the final fig.
    fig
  }

#' Scales the Dimensions of Multiple Figs
#'
#' Finds the dimensions of the largest figs, and adds a border of the given
#' colour around the other figs, to ensure they are all of the same dimensions
#' and scale properly when displayed on in a patchwork together.
#'
#' @param ... Multiple figs created with `fig()`.
#' @param border_colour Colour of the border to be added around the smaller figs.
#'
#' @return A list of figs which have been resized, which can be input directly
#'   into `fig_wrap()` or `patchwork::wrap_plots()`.
#' @export
#'
#' @examples
#' library(figpatch)
#' fl <- image_path <- system.file("extdata",
#'   package = "figpatch",
#'   mustWork = TRUE
#' ) %>%
#'   list.files(
#'     pattern = "png",
#'     full.names = TRUE
#'   )
#'
#' # without scaling
#' fl %>%
#'   lapply(fig) %>%
#'   fig_wrap(ncol = 2)
#'
#' # with scaling
#' fl %>%
#'   lapply(fig) %>%
#'   fig_scale() %>%
#'   fig_wrap(ncol = 2)
fig_scale <- function(..., border_colour = "transparent") {
  if (
    sum(methods::is(...) == c("list", "vector")) == 2 & 
    length(methods::is(...)) == 2
    ) {
    figs <- c(...)
  } else {
    figs <- list(...)
  }
  max_x <- max(sapply(figs, function(x) x$fig_data$x_dim))
  max_y <- max(sapply(figs, function(x) x$fig_data$y_dim))

  lapply(figs, function(x) {
    fig_update(x, max_x, max_y, )
  })
}
