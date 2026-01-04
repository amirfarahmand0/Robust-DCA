summarize_results <- function(all_results) {
  all_summaries <- list()
  for (scen_name in names(all_results)) {
    df <- all_results[[scen_name]]
    summary_df <- df %>%
      group_by(pt) %>%
      summarise(
        scenario = scen_name,
        NB_true = mean(NB_km + bias_km, na.rm = TRUE),
        avg_bias_km = mean(bias_km, na.rm = TRUE),
        avg_bias_ipcw = mean(bias_ipcw, na.rm = TRUE),
        se_km = sd(NB_km, na.rm = TRUE),
        se_ipcw = sd(NB_ipcw, na.rm = TRUE),
        coverage_km = mean(cover_km, na.rm = TRUE),
        coverage_ipcw = mean(cover_ipcw, na.rm = TRUE)
      )
    all_summaries[[scen_name]] <- summary_df
  }
  combined_summary <- do.call(rbind, all_summaries)
  return(combined_summary)
}
save_results_csv <- function(all_results) {
  write.csv(all_results[["informative"]], file = here("output", "informative_results.csv"), row.names = FALSE)
  write.csv(all_results[["non_informative"]], file = here("output", "non_informative_results.csv"), row.names = FALSE)
}
load_results_csv <- function() {
  informative_df <- read.csv(here("output", "informative_results.csv"))
  non_informative_df <- read.csv(here("output", "non_informative_results.csv"))
  list(informative = informative_df, non_informative = non_informative_df)
}
