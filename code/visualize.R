library(ggplot2)
library(dplyr)
library(reshape2)
library(gridExtra)
library(tidyr)  

plot_bias <- function(all_results) {

  combined_results <- bind_rows(
    all_results[["non_informative"]] %>% mutate(scenario = "non_informative"),
    all_results[["informative"]] %>% mutate(scenario = "informative")
  )
  combined_results$scenario <- factor(
    combined_results$scenario,
    levels = c("non_informative", "informative")
  )

  bias_data <- combined_results %>%
    select(scenario, pt, bias_km, bias_ipcw) %>%
    melt(
      id.vars = c("scenario", "pt"),
      measure.vars = c("bias_km", "bias_ipcw"),
      variable.name = "method",
      value.name = "bias"
    ) %>%
    mutate(
      method = ifelse(
        method == "bias_km",
        "Kaplan–Meier",
        "Conditional Inverse Probability of Censoring Weighting"
      )
    )

  p <- ggplot(
    bias_data,
    aes(x = factor(pt), y = bias, fill = method)
  ) +
    geom_boxplot(
      position = position_dodge(0.8),
      width = 0.7,
      outlier.size = 1.2
    ) +
    facet_wrap(
      ~ scenario,
      ncol = 2,
      labeller = as_labeller(c(
        non_informative = "Non-Informative Censoring",
        informative = "Informative Censoring"
      ))
    ) +
    scale_fill_manual(
      values = c(
        "Kaplan–Meier" = "#E69F00",
        "Conditional Inverse Probability of Censoring Weighting" = "#56B4E9"
      ),
      name = NULL
    ) +
    scale_x_discrete(
      labels = function(x) paste0(as.numeric(x) * 100, "%")
    ) +
    labs(
      x = "Risk Threshold",
      y = "True NB - Estimated NB",
      caption = "NB: Net Benefit\nTrue NB: Validation population of size 1 million\nEstimated NB: Subsample of size 500 from the validation population\nNumber of replications: 1,000"
    ) +
    theme_minimal(base_size = 13) +
    theme(
      axis.text.x = element_text(hjust = 0.5),
      strip.text = element_text(size = 12, face = "bold"),
      legend.position = "bottom",
      legend.title = element_text(size = 11),
      legend.text = element_text(size = 10),
      plot.caption = element_text(
        size = 10,
        hjust = 0,
        margin = margin(t = 8)
      )
    )
  print(p)
}
