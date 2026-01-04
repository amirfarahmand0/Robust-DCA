pts <- c(0.01, 0.05, 0.1, 0.25, 0.5, 0.75)  

common_params <- list(
  target_event_pct = 0.4,
  target_t = 4,
  delta_beta = 0,
  target_cens_pct = 0.2
)

non_informative <- list(HRc_Z1 = 1, HRc_Z2 = 1)

scenarios <- list(
  informative = list(HRc_Z1 = 2.65, HRc_Z2 = 2.65),
  non_informative = list(HRc_Z1 = 1, HRc_Z2 = 1)
)

run_simulation <- function() {
  all_results <- list()
  for (scen_name in names(scenarios)) {
    cat("Running scenario:", scen_name, "\n")
    gen_params_train <- c(common_params, non_informative)
    gen_params_train$n <- 1000
    set.seed(123)
    train_data <- do.call(generate_survival_tuned, gen_params_train)
    model <- fit_black_box_model(train_data)
    gen_params_large <- c(common_params, scenarios[[scen_name]])
    gen_params_large$n <- 1000000
    large_data <- do.call(generate_survival_tuned, gen_params_large)
    NB_trues <- compute_true_nb(
      model,
      large_data,
      target_t = 4,
      pt = pts
    )
    results <- future_lapply(1:1000, function(r) {
      print(r)
      valid_idx <- sample(seq_len(nrow(large_data)), 500, replace = FALSE)
      valid_data <- large_data[valid_idx, ]
      run_single_replication(
        model = model,
        NB_trues = NB_trues,
        valid_data = valid_data,
        target_t = 4,
        pts = pts,
        B = 500
      )
    }, future.seed = TRUE)  # Explicit for clarity, but global future.seed=TRUE handles it
    results_df <- do.call(rbind, results)
    all_results[[scen_name]] <- results_df
  }
  return(all_results)
}
