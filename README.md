# Robust Decision Curve Analysis for Survival Risk Prediction Models in the Presence of Informative Censoring

This GitHub repository contains reproducibility materials for the abstract submitted to the 2026 SMDM Annual Meeting: Robust Decision Curve Analysis for Survival Risk Prediction Models in the Presence of Informative Censoring. It includes modular R scripts for our proposed algorithm as well as the simulation study.

## Overview
This project evaluates robust decision curve analysis against the conventional decision curve analysis for survival risk prediction models under informative and non-informative censoring scenarios. Simulations generate survival data, fit Cox models, compute net benefits, and assess bias.

## Requirements
- R >= 4.0
- Packages: Managed via renv (see below)

## Setup and Reproduction Instructions
1. Clone the repo: `git clone https://github.com/amirfarahmand0/Robust-DCA.git`
2. Install dependencies: In R, run `install.packages("renv")` then `renv::restore()`.
3. Load results (for quick analysis): Use pre-saved CSVs in `/output`.
4. Generate the report: Knit `manuscript/abstract_simulation.Rmd` to HTML via RStudio or `rmarkdown::render("manuscript/abstract_simulation.Rmd")`. This loads results, summarizes, and plots.
5. Full simulation (optional, time-intensive): Uncomment `all_results <- run_simulation()` in the Rmd and re-knit.

## Directory Structure
- `/code`: Modular scripts (e.g., setup.R, data_generation.R, simulate.R).
- `/data`: Simulated datasets
- `/manuscript`: abstract_simulation.Rmd (report).
- `/output`: Generated CSVs and results (e.g., informative_results.csv).


## Notes
- Parallelization uses `future` (multisession by default).

## Reproducibility Statement
These analyses were conducted using both fully reproducible simulation runs and pre-generated outputs. Because generating the simulation results is computationally intensive (e.g., 1,000 replications with bootstrapping), pre-generated simulation outputs (CSVs in `/output`) and datasets (CSVs in `/data`) are also provided. The complete simulations can be regenerated from source by setting `reproduce <- TRUE` in the Rmd (with an optional `seed_number` for reproducibility), which triggers `run_simulation()`. Timing information and computational specifications are reported in the knitted report. Package dependencies can be restored using `renv::restore()`.


