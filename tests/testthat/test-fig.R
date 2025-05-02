test_that("fig() throws error on invalid path and works silently on valid image", {
  expect_error(
    fig("brokenlink"),
    "The file 'brokenlink' does not exist. Please provide a valid image path."
  )
  
  expect_silent({
    fig(
      system.file("extdata", "fig.png", package = "figpatch", mustWork = TRUE)
    )
  })
})
