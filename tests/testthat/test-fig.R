test_that("Test Reading", {
  expect_error(
    # fail while reading in rubbish link
    fig("brokenlink"),
    {
      "No such file or directory"
    }
  )
  expect_silent({
    # read in without trouble
    temp <- fig(
      system.file("extdata", "fig.png", package = "figpatch", mustWork = TRUE)
    )
  })
})
