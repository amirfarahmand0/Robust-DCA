# Robust Decision Curve Analysis for Survival Risk Prediction Models in the presence of Informative Censoring

This GitHub repository contains reproducibility materials for the Robust Decision Curve Analysis project submitted to SMDM (Quantitative Methods and Theoretical Developments 
). It includes modular R scripts for data simulation, modeling, net benefit calculations, bootstrapping, replications, summarization, and visualization.

## Overview
This project evaluates robust decision curve analysis methods (Kaplan-Meier vs. Conditional IPCW) under informative and non-informative censoring scenarios. Simulations generate survival data, fit Cox models, compute net benefits, and assess bias/coverage via bootstrapping.

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
This repository contains all code and workflows required to reproduce the simulation results and figures reported in the abstract. Due to computational cost, pre-generated results are provided, but full simulations can be rerun from source.

