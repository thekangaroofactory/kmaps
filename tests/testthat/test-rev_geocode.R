
# -- setup
cache_dir <- file.path(test_path(), "test_cache")
dir.create(cache_dir)
Sys.setenv("R_KMAPS_CACHE" = cache_dir)


test_that("rev_geocode works", {

  # baseline (pick one)
  # to avoid spamming the API with same request
  coord_lng <- runif(1, -1.038, 7.926)
  coord_lat <- runif(1, 43.694, 48.949)
  x <- rev_geocode(lng = coord_lng, lat = coord_lat)

  expect_s3_class(x, "data.frame")
  expect_shape(x, nrow = 1)

  # repeat
  y <- rev_geocode(lng = coord_lng, lat = coord_lat)
  expect_identical(x, y)

  # multiple values (pick two)
  coord_lng <- runif(2, -1.038, 7.926)
  coord_lat <- runif(2, 43.694, 48.949)
  x <- rev_geocode(lng = coord_lng, lat = coord_lat)
  expect_s3_class(x, "data.frame")
  expect_shape(x, nrow = 2)

  # repeat
  y <- rev_geocode(lng = coord_lng, lat = coord_lat)
  expect_identical(x, y)

})

# -- cleanup
unlink(cache_dir, recursive = TRUE)
Sys.unsetenv("R_KMAPS_CACHE")
