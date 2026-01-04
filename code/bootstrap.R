bootstrap_ci <- function(valid_data, model, estimator_func, B = 200, target_t = 1, pt, nb_col) {
  if (missing(pt)) stop("pt must be provided")
  if (missing(nb_col)) stop("nb_col must be provided")
  n <- nrow(valid_data)
  results <- lapply(pt, function(z) {  # Keep serial lapply for pts (small)
    boot_nbs <- future_sapply(1:B, function(b) {
      boot_idx <- sample(1:n, n, replace = TRUE)
      boot_data <- valid_data[boot_idx, ]
      estimator_func(model, boot_data, target_t, z)[[nb_col]][1]
    }, future.seed = TRUE)  
    ci <- quantile(boot_nbs, probs = c(0.05, 0.95))
    data.frame(pt = z, ci_lower = ci[1], ci_upper = ci[2])
  })
  do.call(rbind, results)
}
