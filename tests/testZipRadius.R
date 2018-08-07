library(testthat)

test_that("distance checks out",{
  test <- zipRadius("30316", 10)
  expect_that(test, is_a("data.frame"))
  expect_that(test$Distance[1], equals(5.26))
})
