generate_survival_tuned <- function(n = 800,
                                    target_event_pct = 0.35, 
                                    target_t = 1,
                                    delta_beta = 0.45,
                                    HRc_Z1 ,
                                    HRc_Z2 ,
                                    target_cens_pct = 0.3
                                ) {
  # 1. Markers
  Sigma <- matrix(c(1, 0.5, 0.5, 1), 2, 2)
  Z <- rmvnorm(n, mean = c(0,0), sigma = Sigma)
  Z1 <- Z[,1]; Z2 <- Z[,2]
 
  # 2. True prognostic effects
  beta_Z1 <- 1 + delta_beta
  beta_Z2 <- 1 - delta_beta
  lp_event <- beta_Z1 * Z1 + beta_Z2 * Z2
 
  # 3. Censoring dependence
  gamma1 <- log(HRc_Z1)
  gamma2 <- log(HRc_Z2)
  exp_gamma <- exp(gamma1 * Z1 + gamma2 * Z2)
 
  # 4. Tune lambda_event so that EXACTLY target_event_pct have true_T <= target_t
  optim_event <- function(log_lambda) {
    lambda <- exp(log_lambda)
    prob <- 1 - exp(-lambda * target_t * exp(lp_event))
    abs(mean(prob) - target_event_pct)
  }
  lambda_event <- exp(optim(par = log(0.4), fn = optim_event,
                            method = "Brent", lower = -10, upper = 10)$par)
 
  # 5. Tune censoring for OBSERVED censoring by t
  optim_cens <- function(log_lambda_c) {
    lambda_c <- exp(log_lambda_c)
    rate_c <- lambda_c * exp_gamma
    rate_e <- lambda_event * exp(lp_event)
    term1 <- rate_c / (rate_c + rate_e)
    term2 <- 1 - exp(-target_t * (rate_c + rate_e))
    prob_obs_cens <- term1 * term2
    abs(mean(prob_obs_cens) - target_cens_pct)
  }
  lambda_cens <- exp(optim(par = log(0.1), fn = optim_cens,  # Lower initial for new formula
                           method = "Brent", lower = -10, upper = 10)$par)
 
  # 6. Generate times
  true_T <- rexp(n, rate = lambda_event * exp(lp_event))
  C <- rexp(n, rate = lambda_cens * exp_gamma)
 
  obs_time <- pmin(true_T, C)
  delta <- as.integer(true_T <= C)
 
  # 7. Summary — now correct!
  latent_event <- mean(true_T <= target_t)
  obs_event <- mean(obs_time <= target_t & delta == 1)
  censored <- mean(obs_time <= target_t & delta == 0)
  at_risk <- mean(obs_time > target_t)
 
  #cat("=== CORRECT Simulation Summary (Latent Incidence) ===\n")
  #cat(sprintf("Target latent event (true_T <= %.1f): %.1f%%\n", target_t, 100*target_event_pct))
  #cat(sprintf("Actual latent event: %.1f%%\n", 100*latent_event))
  #cat(sprintf("Observed events by t: %.1f%%\n", 100*obs_event))
  cat(sprintf("Censored by t: %.1f%%\n", 100*censored))
  #cat(sprintf("Still at risk at t: %.1f%%\n\n", 100*at_risk))
 
  data.frame(obs_time = obs_time,
             delta = delta,
             true_T = true_T,
             Z1 = Z1,
             Z2 = Z2)
}

