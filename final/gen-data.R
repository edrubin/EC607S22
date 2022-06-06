
# Setup ----------------------------------------------------------------------------------
  # Load packages
  pacman::p_load(fastverse, fixest, magrittr, here)
  fastverse_extend(topics = c('VI'))

# Define DGP -----------------------------------------------------------------------------
  # Sample size
  n = 4e4
  # Seed
  set.seed(7)
  # Define functions
  y0 = function(x) 0.7 / (1 + exp(-3 * x))
  y1 = function(x) 0.85 / (1 + exp(-4 * x)) + 0.3
  sim_dt = data.table(xc = rnorm(n))
  # Generate potential outcomes
  sim_dt[, `:=`(
    y0 = y0(xc),
    y1 = y1(xc),
    e0 = rnorm(.N),
    e1 = rnorm(.N)
  )]
  sim_dt[, `:=`(
    y0 = y0 + e0,
    y1 = y1 + e0 + e1
  )]
  # Round the running variable
  sim_dt[, xc := round(xc, 2)]
  # Define outcome
  sim_dt[, y := (xc < 0.2) * y0 + (xc >= 0.2) * y1 + rnorm(n, sd = 0.04)]
  # Shift the variables
  sim_dt[, `:=`(
    d = 1 * (xc >= 0.2),
    x = xc,
    w = runif(.N, min = 0, max = 100) %>% round(2)
  )]
  # Drop variables
  sim_dt[, c('xc', 'y0', 'y1', 'e0', 'e1') := NULL]

  # Check sharpness
  sim_dt[, .(d = fmean(d)), by = x] %>% plot()
  sim_dt[, .(d = fmean(d)), by = .(x-0.2)] %>% plot()
  # Check treatment effect
  ggplot(sim_dt, aes(x,y)) + geom_point(size = 0.1, alpha = 0.5) + theme_minimal()
  sim_dt[, .(d = fmean(y)), by = x] %>% plot()

  # Save the CSV
  fwrite(x = sim_dt, file = here("final-data.csv"))

  # Estimation dataset
  est_dt = sim_dt
  est_dt[, x := x - 0.2]

  feols(y ~ x + I(x > 0), data = est_dt)
  feols(y ~ x + I(x > 0), data = est_dt[between(x, -1, 1)])
  feols(y ~ x + I(x > 0) + x : I(x > 0), data = est_dt[between(x, -1, 1)])
  feols(y ~ x + I(x^2) + I(x > 0) + x : I(x > 0) + I(x^2) : I(x > 0), data = est_dt[between(x, -1, 1)])

  # ggplot(data = est_dt, aes(x = x, y = y)) +
  ggplot(data = est_dt[between(x, -1, 1)], aes(x = x, y = y)) +
  geom_point(size = 0.5, alpha = 0.6) +
  geom_smooth(
    se = FALSE,
    method = lm, formula = y ~ x + I(x > 0)
    # method = lm, formula = y ~ x + I(x > 0) + x : I(x > 0)
    # method = lm, formula = y ~ x + I(x^2) + I(x > 0) + x : I(x > 0) + I(x^2) : I(x > 0)
    # method = loess, formula = y ~ x + I(x > 0)
  ) +
  theme_minimal()