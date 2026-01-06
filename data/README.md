# Data Directory

This directory contains simulated datasets generated via code/data_generation.R.

- train_data.csv: Training data (n=1000) for the Cox model.
- informative_large_data.csv: Large simulated data (n=1,000,000) for informative censoring scenario.
- non_informative_large_data.csv: Large simulated data (n=1,000,000) for non-informative scenario.

### Replication and resampling design

For each large dataset (informative and non-informative censoring):

- **1,000 Monte Carlo replications** are performed.
- In each replication, a **subsample of size 500 is drawn without replacement**.
- Net Benefit (NB) is computed for each subsample using:
  - **Conditional IPCW**
  - **Kaplan–Meier (KM)**–based estimation.
- **True Net Benefit** is computed using the **entire large dataset** (*n* = 1,000,000), which serves as a population-level reference.

This design evaluates the bias and variability of NB estimators under repeated sampling while treating the large dataset as an approximation of the true data-generating process.


To regenerate: Run code/generate_data.R.
