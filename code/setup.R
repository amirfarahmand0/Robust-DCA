library(data.table)
library(survival)
library(survivalROC)
library(mvtnorm)
library(pbapply)
library(future.apply)
library(parallel)
library(dplyr)
library(here)  

plan(multisession, workers = detectCores() - 1)  # Or multicore if on Unix/Mac
future.seed <- TRUE  
