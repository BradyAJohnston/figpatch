---
output: github_document
---

<!-- README.md is generated from README.Rmd. Please edit that file -->



# figpatch

<!-- badges: start -->
<!-- badges: end -->

The goal of figpatch is to create an easy way to incorporate external figures
and images into figures assembled with
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


```r
library(figpatch)
#> Error in library(figpatch): there is no package called 'figpatch'
library(ggplot2)
library(patchwork)
```

To use images inside of a patchwork object, they need to be converted to a
`{ggplot}` object via `fig()`. Once converted, you can assemble the
`{patchwork}` as you would otherwise with `+ / - * &` or `wrap_plots()`.


```r
img <- fig("inst/extdata/fig.png")
#> Error in fig("inst/extdata/fig.png"): could not find function "fig"

plt <- ggplot(mtcars) + 
  aes(mpg, cyl) + 
  geom_point()

pat <- patchwork::wrap_plots(img, plt, plt, img)
#> Error in is.ggplot(x): object 'img' not found
pat
#> Error in eval(expr, envir, enclos): object 'pat' not found
```

The `aspect.ratio` of the figs is set to the dimensions of the image, but the
plots can still resize as you would expect. For each plot that aligns with a
fig, it's dimensions will match that of the fig (as above). If however it only
aligns on one axis, then the other is free to resize to fill up the total image
space (as below).


```r
wrap_plots(plt, img, plt, img, ncol = 2)
#> Error in wrap_plots(plt, img, plt, img, ncol = 2): object 'img' not found
```

If for some reason you want your fig to also resize (and thus distort your
image) then you can specify a particular `aspect.ratio` or let it _be free!_


```r
free_fig <- fig("inst/extdata/fig.png", aspect.ratio = "free")
#> Error in fig("inst/extdata/fig.png", aspect.ratio = "free"): could not find function "fig"

wrap_plots(free_fig, plt, ncol = 1)
#> Error in is.ggplot(x): object 'free_fig' not found
```

_Elegant._

### Tagging
Patchwork already provides support for easy tagging of sub-plots and sub-figures
using `plot_annotation()`.

```r
pat + plot_annotation(tag_levels = "A")
#> Error in eval(expr, envir, enclos): object 'pat' not found
```

For a lot of figures that include images, tags should be placed on top of the images themselves.
Tagging in {patchwork} currently utilises the ggplot `tag` option 
from `ggplot2::labs(tag = ...)` but which currently [doesn't support tagging inside plot borders.](https://github.com/tidyverse/ggplot2/issues/4297)

Lets see how it plays out.

#### The assembled figs.

```r
knitr::opts_chunk$set(fig.height = 2, fig.width = 7)
```



```r
patchwork::wrap_plots(img, img, img, nrow = 1)
#> Error in is.ggplot(x): object 'img' not found
```

### Patchwork tagging the figs.

```r
patchwork::wrap_plots(img, img, img, nrow = 1) + 
  plot_annotation(tag_levels = "A")
#> Error in is.ggplot(x): object 'img' not found
```


### {figpatch} tagging the figs
To add internal tags to the figs, use the `figlab()` function. Assembling with
{patchwork} can continue as normal.


```r
img1 <- figlab(img, "A")
#> Error in figlab(img, "A"): could not find function "figlab"
img2 <- figlab(img, "(B)")
#> Error in figlab(img, "(B)"): could not find function "figlab"
img3 <- figlab(img, "misc")
#> Error in figlab(img, "misc"): could not find function "figlab"

patchwork::wrap_plots(img1, img2, img3, nrow = 1)
#> Error in is.ggplot(x): object 'img1' not found
```

A number of default positions can be supplied to `figlab(pos = ...)` or a custom
vector which will place the text in `npc` coordinates (0 to 1 for both `x` and `y`) and
automatically adjust for the aspect ratio of the fig.


```r
img1 <- figlab(img, "A", pos = "topright")
#> Error in figlab(img, "A", pos = "topright"): could not find function "figlab"
img2 <- figlab(img, "(B)", pos = "bottomleft")
#> Error in figlab(img, "(B)", pos = "bottomleft"): could not find function "figlab"
img3 <- figlab(img, "misc", pos = c(0.4, 0.9))
#> Error in figlab(img, "misc", pos = c(0.4, 0.9)): could not find function "figlab"

wrap_plots(img1, img2, img3, nrow = 1)
#> Error in is.ggplot(x): object 'img1' not found
```

## `figwrap()`
To quickly label and wrap multiple figures, use `figwrap()` 

To add borders around individual figures, use `b_*` options inside of `figwrap()` 
or specify them individually with `fig()`.


```r
figwrap(
  list(img, img, img),
  "A",
  prefix = "(",
  suffix = ")",
  b_col = "black"
)
#> Error in figwrap(list(img, img, img), "A", prefix = "(", suffix = ")", : could not find function "figwrap"
```



Assembling lots of figures.

```r
knitr::opts_chunk$set(fig.height = 5, fig.width = 7)
```


```r
figs <- lapply(1:9, function(x) img)
#> Error in FUN(X[[i]], ...): object 'img' not found

figwrap(
  figs,
  nrow = 3,
  tag = 1,
  suffix = ")",
  b_col = "gray20",
  b_size = 2
)
#> Error in figwrap(figs, nrow = 3, tag = 1, suffix = ")", b_col = "gray20", : could not find function "figwrap"
```

Adjust the padding around plots with `b_margins` and change the unit used with 
`b_unit`.

```r
figwrap(
  figs,
  nrow = 3,
  tag = 1,
  suffix = ")",
  b_col = "gray20",
  b_size = 2, 
  b_margins = 0.02
)
#> Error in figwrap(figs, nrow = 3, tag = 1, suffix = ")", b_col = "gray20", : could not find function "figwrap"
```


## Adding specific sub-plot text.
At the end of the day, each of the figs is just a `ggplot()` object. More
support for labelling is planned, but at the moment axis labels can be used to
add text below and above.
Designs in `{patchwork}` can also be used to arrange the [figures specifically](https://patchwork.data-imaginist.com/articles/guides/layout.html#moving-beyond-the-grid).


```r
img1 <- img1 + 
  labs(x = "A label below the fig.")
#> Error in eval(expr, envir, enclos): object 'img1' not found

img2 <- img2 + 
  labs(x = "An italic label below the fig.") +
  theme(axis.title.x = element_text(face = "italic"))
#> Error in eval(expr, envir, enclos): object 'img2' not found

img3 <- img3 + 
  labs(x = "Below you will find a fig.") + 
  scale_x_continuous(position = "top") + 
  theme(axis.title.x.top = element_text(margin = margin(b = 5)))
#> Error in eval(expr, envir, enclos): object 'img3' not found
  
img3
#> Error in eval(expr, envir, enclos): object 'img3' not found

design <- "AB
           CC"

wrap_plots(img1, img2, img3, design = design)
#> Error in is.ggplot(x): object 'img1' not found
```

