# Code Directory

This directory contains the modular R scripts implementing the Robust Decision Curve Analysis (RDCA) algorithm for survival models with informative censoring. The main implementation is in `abstract_simulation.Rmd`, which is reproducible see the knitted HTML version in `abstract_simulation.html`.

Brief descriptions of the .R files:
- `setup.R`: Loads libraries and configures parallel processing.
- `data_generation.R`: Function to generate tuned survival data.
- `modeling.R`: Functions for fitting Cox models and predicting risks.
- `components.R`: Functions to compute prevalence, sensitivity, and specificity (true, KM, CIPCW).
- `net_benefit.R`: Functions to calculate net benefits (true, KM, CIPCW).
- `bootstrap.R`: Function for bootstrap confidence intervals.
- `replication.R`: Function for single replication runs.
- `simulate.R`: Parameters, scenarios, and main simulation loop.
- `summarize.R`: Functions to summarize results and handle CSV I/O.
- `visualize.R`: Functions for plotting (e.g., bias plots).
- `generate_data.R`: Script to generate and save simulated datasets to /data.
