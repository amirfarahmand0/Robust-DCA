true_components <- function(data, t, z, risk_score) {
  dt <- as.data.table(data)
  D <- dt$true_T <= t
  pos <- risk_score > z
  c(prevalence = mean(D),
    sensitivity = mean(pos[D]),
    specificity = 1 - mean(pos[!D]))
}

km_components <- function(data, t, z, risk_score) {
  dt <- as.data.table(data)
  # Prevalence
  fit <- survfit(Surv(obs_time, delta) ~ 1, data = dt)
  S_t <- if (t %in% fit$time) fit$surv[fit$time == t] else
    approx(fit$time, fit$surv, xout = t, method = "linear", rule = 2)$y
  prev <- 1 - S_t
  # Se/Sp
  roc <- survivalROC(Stime = dt$obs_time, status = dt$delta,
                     marker = risk_score, predict.time = t,
                     cut.values = z, method = "KM")
  Se <- roc$TP[2]; Sp <- 1 - roc$FP[2]
  c(prevalence = prev, sensitivity = Se, specificity = Sp)
}

ipcw_components <- function(data, t, z, risk_score) {
  dt <- as.data.table(data)
  # Fit censoring model
  cox_cens <- coxph(Surv(obs_time, 1 - delta) ~ Z1 + Z2, data = dt)
  bh <- basehaz(cox_cens, centered = TRUE)
  setorder(bh, time)
    get_Lambda0 <- function(u) {
    approx(bh$time, bh$hazard, xout = u, method = "linear", rule = 2)$y
  }
  
  lp <- predict(cox_cens, type = "lp")
  
  # For prevalence and sensitivity (weights at obs_time)
  Lambda0_obs <- get_Lambda0(dt$obs_time)
  G_hat_obs <- pmax(exp(-Lambda0_obs * exp(lp)), 1e-10)  # Clip to epsilon
  weight_event <- dt$delta / G_hat_obs  # delta / Sc(obs_time | Z)
  
  indicator_event <- (dt$obs_time <= t)
  
  # Prevalence: mean(weight_event * indicator_event)
  prev <- mean(weight_event * indicator_event)
  
  # Sensitivity
  indicator_pos <- (risk_score > z)
  num_se <- sum(weight_event * indicator_event * indicator_pos)
  den_se <- sum(weight_event * indicator_event)
  Se <- if (den_se == 0) 0 else num_se / den_se
  
  # For specificity (weights at t)
  Lambda0_t <- get_Lambda0(t)
  G_hat_t <- pmax(exp(-Lambda0_t * exp(lp)), 1e-10)  # Clip to epsilon
  indicator_surv <- (dt$obs_time > t)
  
  # Specificity
  indicator_neg <- (risk_score <= z)
  num_sp <- sum(indicator_surv * indicator_neg / G_hat_t)
  den_sp <- sum(indicator_surv / G_hat_t)
  Sp <- if (den_sp == 0) 1 else num_sp / den_sp
  
  c(prevalence = prev, sensitivity = Se, specificity = Sp)
}


