test_that("fig() throws error on invalid path and works silently on valid image", {
  expect_error(
    fig("brokenlink"),
    "No such file or directory"
  )
  
  expect_silent({
    fig(
      system.file("extdata", "fig.png", package = "figpatch", mustWork = TRUE)
    )
  })
})
