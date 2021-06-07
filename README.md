
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
`{patchwork}` as you would otherwise with `+ / - * &` or
`patchwork::wrap_plots()`.

``` r
img <- fig("inst/extdata/fig.png")

plt <- ggplot(mtcars) + 
  aes(mpg, cyl) + 
  geom_point() + 
  theme(plot.tag = element_text(hjust = 0, 
                                vjust = 1))

pat <- patchwork::wrap_plots(img, plt, plt, img)
pat
```

![](README_files/figure-gfm/figpatch-1.png)<!-- -->

Patchwork already provides support for quick labelling of sub-plots and
sub-figures using `patchwork::plot_annotation()`.

``` r
pat + plot_annotation(tag_levels = "A")
```

![](README_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

For figures which are all just images, labelling *on top* of the image
is sometimes desired. {patchwork} currently utilises the ggplot `tag`
option from `ggplot2::labs(tag = ...)` but which currently [doesn’t
support tagging inside plot
borders.](https://github.com/tidyverse/ggplot2/issues/4297).

#### The assembled patchwork.

``` r
knitr::opts_chunk$set(fig.height = 2, fig.width = 7)
```

``` r
patchwork::wrap_plots(img, img, img, nrow = 1)
```

![](README_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

### The default tagging behaviour.

``` r
patchwork::wrap_plots(img, img, img, nrow = 1) + 
  plot_annotation(tag_levels = "A")
```

![](README_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

### Manually Tagging

A current solution to this is the `figlab()` function which will add a
supplied tag to the supplied fig.

``` r
img1 <- figlab(img, "A")
img2 <- figlab(img, "(B)")
img3 <- figlab(img, "misc")

patchwork::wrap_plots(img1, img2, img3, nrow = 1)
```

![](README_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

A number of default positions are available, as well as support for
custom `x & y` coordinates.

``` r
img1 <- figlab(img, "A", pos = "topright")
img2 <- figlab(img, "(B)", pos = "bottomleft")
img3 <- figlab(img, "misc", pos = c(0.4, 0.9))

patchwork::wrap_plots(img1, img2, img3, nrow = 1)
```

![](README_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

## `figwrap()`

To quickly label and wrap multiple figures, use `figwrap()`

``` r
figwrap(list(img, img, img), "A", prefix = "(", suffix = ")")
```

![](README_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

Larger figures again.

``` r
knitr::opts_chunk$set(fig.height = 5, fig.width = 7)
```

Lots of figures assembled.

``` r
figs <- lapply(1:9, function(x) img)

figwrap(figs, nrow = 3, labelling = 1, suffix = ")")
```

![](README_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->
