
library(here)
source(here("code/setup.R"))
source(here("code/data_generation.R"))
source(here("code/simulate.R"))  # For params like common_params, non_informative, scenarios


set.seed(123)

# Generate train_data (common, non-informative, n=1000)
gen_params_train <- c(common_params, non_informative)
gen_params_train$n <- 1000
train_data <- do.call(generate_survival_tuned, gen_params_train)
write.csv(train_data, here("data", "train_data.csv"), row.names = FALSE)

# Generate large_data for each scenario (n=1,000,000)
for (scen_name in names(scenarios)) {
  cat("Generating large data for scenario:", scen_name, "\n")
  gen_params_large <- c(common_params, scenarios[[scen_name]])
  gen_params_large$n <- 1000000
  large_data <- do.call(generate_survival_tuned, gen_params_large)
  write.csv(large_data, here("data", paste0(scen_name, "_large_data.csv")), row.names = FALSE)
}

cat("Datasets generated and saved to /data directory as CSV.\n")
