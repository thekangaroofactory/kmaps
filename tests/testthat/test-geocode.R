
# -- setup
cache_dir <- file.path(test_path(), "test_cache")
dir.create(cache_dir)
Sys.setenv("R_KMAPS_CACHE" = cache_dir)


test_that("geocode works", {
  
  # to avoid spamming the API with same request
  data <- c("Musée du Louvre",
            "Musée Lamartine",
            "Musée Louis Jourdan",
            "Musée Théophile Jouglet",
            "Musée Victor Hugo",
            "Musée Joseph-Denais",
            "Musée Baron Martin",
            "Musée Jérôme Carcopino",
            "Musée Henri Dupuis",
            "Musée de Mayotte")
  
  # baseline (pick one)
  address <- sample(data, 1)
  x <- geocode(address)
  expect_s3_class(x, "data.frame")
  expect_shape(x, nrow = 1)
  
  # repeat
  y <- geocode(address)
  expect_identical(x, y)
  
  # multiple values (pick two)
  addresses <- sample(data, 2)
  x <- geocode(addresses)
  expect_s3_class(x, "data.frame")
  expect_shape(x, nrow = 2)
  
  # repeat
  y <- geocode(addresses)
  expect_identical(x, y)
  
  # -- negative test
  x <- geocode(x = NULL)
  str(x)
  expect_s3_class(x, "data.frame")
  expect_shape(x, nrow = 0)

})

# -- cleanup
unlink(cache_dir, recursive = TRUE)
Sys.unsetenv("R_KMAPS_CACHE")
