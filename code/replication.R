run_single_replication <- function(
  model,
  NB_trues,
  valid_data,
  target_t = 1,
  pts,
  B = 200
) {
  if (missing(pts)) stop("pts must be provided")
  results <- lapply(pts, function(pt_val) {
    NB_true_val <- NB_trues$NB_true[NB_trues$pt == pt_val]
    km_df <- compute_km_nb(model, valid_data, target_t, pt_val)
    ipcw_df <- compute_ipcw_nb(model, valid_data, target_t, pt_val)
    ci_km <- bootstrap_ci(valid_data, model, compute_km_nb, B, target_t, pt_val, nb_col = "NB_km")
    ci_ipcw <- bootstrap_ci(valid_data, model, compute_ipcw_nb, B, target_t, pt_val, nb_col = "NB_ipcw")
    data.frame(
      pt = pt_val,
      NB_km = km_df$NB_km,
      NB_ipcw = ipcw_df$NB_ipcw,
      bias_km = NB_true_val - km_df$NB_km,
      bias_ipcw = NB_true_val - ipcw_df$NB_ipcw,
      ci_km_lower = ci_km$ci_lower,
      ci_km_upper = ci_km$ci_upper,
      ci_ipcw_lower = ci_ipcw$ci_lower,
      ci_ipcw_upper = ci_ipcw$ci_upper,
      NB_True = NB_true_val
    ) %>% 
    mutate(
      cover_km = (NB_true_val >= ci_km_lower & NB_true_val <= ci_km_upper),
      cover_ipcw = (NB_true_val >= ci_ipcw_lower & NB_true_val <= ci_ipcw_upper)
    )
  })
  do.call(rbind, results)
}
