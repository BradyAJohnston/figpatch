
<!-- README.md is generated from README.Rmd. Please edit that file -->

# figpatch

<!-- badges: start -->
<!-- badges: end -->

The goal of figpatch is to create an easy way to incorporate external
figures and images into figures assembled with
[{patchwork}](https://patchwork.data-imaginist.com/).

## Installation

<!-- You can install the released version of figpatch from [CRAN](https://CRAN.R-project.org) with: -->
<!-- ``` r -->
<!-- install.packages("figpatch") -->
<!-- ``` -->

Install the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("BradyAJohnston/figpatch")
```

## Example

``` r
library(figpatch)
library(ggplot2)
library(patchwork)
```

To use images inside of a patchwork object, they need to be converted to
a `{ggplot}` object via `fig()`. Once converted, you can assemble the
`{patchwork}` as you would otherwise with `+ / - * &` or `wrap_plots()`.

``` r
img <- fig("inst/extdata/fig.png")

plt <- ggplot(mtcars) + 
  aes(mpg, cyl) + 
  geom_point()

pat <- patchwork::wrap_plots(img, plt, plt, img)
pat
```

<img src="man/figures/README-figpatch-1.png" width="100%" />

The `aspect.ratio` of the figs is set to the dimensions of the image,
but the plots can still resize as you would expect. For each plot that
aligns with a fig, it’s dimensions will match that of the fig (as
above). If however it only aligns on one axis, then the other is free to
resize to fill up the total image space (as below).

``` r
wrap_plots(plt, img, plt, img, ncol = 2)
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" />

If for some reason you want your fig to also resize (and thus distort
your image) then you can specify a particular `aspect.ratio` or let it
*be free!*

``` r
free_fig <- fig("inst/extdata/fig.png", aspect.ratio = "free")

wrap_plots(free_fig, plt, ncol = 1)
```

<img src="man/figures/README-unnamed-chunk-3-1.png" width="100%" />

*Elegant.*

### Tagging

Patchwork already provides support for easy tagging of sub-plots and
sub-figures using `plot_annotation()`.

``` r
pat + plot_annotation(tag_levels = "A")
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />

For a lot of figures that include images, tags should be placed on top
of the images themselves. Tagging in {patchwork} currently utilises the
ggplot `tag` option from `ggplot2::labs(tag = ...)` but which currently
[doesn’t support tagging inside plot
borders.](https://github.com/tidyverse/ggplot2/issues/4297)

Lets see how it plays out.

#### The assembled figs.

``` r
knitr::opts_chunk$set(fig.height = 2, fig.width = 7)
```

``` r
patchwork::wrap_plots(img, img, img, nrow = 1)
```

<img src="man/figures/README-unnamed-chunk-6-1.png" width="100%" />

### Patchwork tagging the figs.

``` r
patchwork::wrap_plots(img, img, img, nrow = 1) + 
  plot_annotation(tag_levels = "A")
```

<img src="man/figures/README-unnamed-chunk-7-1.png" width="100%" />

### {figpatch} tagging the figs

To add internal tags to the figs, use the `figlab()` function.
Assembling with {patchwork} can continue as normal.

``` r
img1 <- figlab(img, "A")
img2 <- figlab(img, "(B)")
img3 <- figlab(img, "misc")

patchwork::wrap_plots(img1, img2, img3, nrow = 1)
```

<img src="man/figures/README-unnamed-chunk-8-1.png" width="100%" />

A number of default positions can be supplied to `figlab(pos = ...)` or
a custom vector which will place the text in `npc` coordinates (0 to 1
for both `x` and `y`) and automatically adjust for the aspect ratio of
the fig.

``` r
img1 <- figlab(img, "A", pos = "topright")
img2 <- figlab(img, "(B)", pos = "bottomleft")
img3 <- figlab(img, "misc", pos = c(0.4, 0.9))

wrap_plots(img1, img2, img3, nrow = 1)
```

<img src="man/figures/README-unnamed-chunk-9-1.png" width="100%" />

## `figwrap()`

To quickly label and wrap multiple figures, use `figwrap()`

To add borders around individual figures, use `b_*` options inside of
`figwrap()` or specify them individually with `fig()`.

``` r
figwrap(
  list(img, img, img),
  "A",
  prefix = "(",
  suffix = ")",
  b_col = "black"
)
```

<img src="man/figures/README-unnamed-chunk-10-1.png" width="100%" />

Assembling lots of figures.

``` r
knitr::opts_chunk$set(fig.height = 5, fig.width = 7)
```

``` r
figs <- lapply(1:9, function(x) img)

figwrap(
  figs,
  nrow = 3,
  tag = 1,
  suffix = ")",
  b_col = "gray20",
  b_size = 2
)
```

<img src="man/figures/README-unnamed-chunk-12-1.png" width="100%" />

Adjust the padding around plots with `b_margins` and change the unit
used with `b_unit`.

``` r
figwrap(
  figs,
  nrow = 3,
  tag = 1,
  suffix = ")",
  b_col = "gray20",
  b_size = 2, 
  b_margins = 0.02
)
```

<img src="man/figures/README-unnamed-chunk-13-1.png" width="100%" />

## Adding specific sub-plot text.

At the end of the day, each of the figs is just a `ggplot()` object.
More support for labelling is planned, but at the moment axis labels can
be used to add text below and above. Designs in `{patchwork}` can also
be used to arrange the [figures
specifically](https://patchwork.data-imaginist.com/articles/guides/layout.html#moving-beyond-the-grid).

``` r
img1 <- img1 + 
  labs(x = "A label below the fig.")

img2 <- img2 + 
  labs(x = "An italic label below the fig.") +
  theme(axis.title.x = element_text(face = "italic"))

img3 <- img3 + 
  labs(x = "Below you will find a fig.") + 
  scale_x_continuous(position = "top") + 
  theme(axis.title.x.top = element_text(margin = margin(b = 5)))

design <- "AB
           CC"

wrap_plots(img1, img2, img3, design = design)
```

<img src="man/figures/README-unnamed-chunk-14-1.png" width="100%" />
