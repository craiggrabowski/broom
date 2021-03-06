context("felm tidiers")

N <- 1e2
DT <- data.frame(
  id = sample(5, N, TRUE),
  v1 = sample(5, N, TRUE),
  v2 = sample(1e6, N, TRUE),
  v3 = sample(round(runif(100, max = 100), 4), N, TRUE),
  v4 = sample(round(runif(100, max = 100), 4), N, TRUE)
)

test_that("felm tidiers work", {
  skip_if_not_installed("lfe")
  result_felm <- lfe::felm(v2 ~ v3, DT)

  td <- tidy(result_felm)
  check_tidy(td, exp.row = 2, exp.col = 5)

  au <- augment(result_felm)
  check_tidy(au, exp.col = 7)

  gl <- glance(result_felm)
  check_tidy(gl, exp.col = 7)
})

test_that("confidence interval and fixed effects estimates work", {
  skip_if_not_installed("lfe")
  DT$v1[1] <- NA_integer_
  result_felm <- lfe::felm(v2 ~ v3 | id + v1, DT, na.action = na.exclude)
  td <- tidy(result_felm, conf.int = TRUE, fe = TRUE)
  check_tidy(td, exp.row = 11, exp.col = 9)

  td <- tidy(result_felm, conf.int = TRUE, fe = TRUE, fe.error = FALSE)
  check_tidy(td, exp.row = 11, exp.col = 9)

  au <- augment(result_felm)
  check_tidy(au, exp.col = 11)
})

test_that("augment felm works when formula is passed as a variable ", {
  skip_if_not_installed("lfe")
  my_formula <- v2 ~ v4
  result_felm <- lfe::felm(my_formula, DT)

  td <- tidy(result_felm)
  check_tidy(td, exp.row = 2, exp.col = 5)

  au <- augment(result_felm)
  check_tidy(au, exp.col = 7)
})
