fit_black_box_model <- function(train_data) {
  coxph(Surv(obs_time, delta) ~ Z1 + Z2, data = train_data)
}

predict_risk <- function(model, data, target_t = 1) {
  lp <- predict(model, newdata = data, type = "lp")  # Centered
  bh <- basehaz(model, centered = TRUE)  # Match centering
  H0_t <- if (target_t <= max(bh$time)) {
    approx(bh$time, bh$hazard, xout = target_t, method = "linear", rule = 2)$y
  } else {
    tail(bh$hazard, 1)
  }
  risk <- 1 - exp(-H0_t * exp(lp))
  return(risk)
}
